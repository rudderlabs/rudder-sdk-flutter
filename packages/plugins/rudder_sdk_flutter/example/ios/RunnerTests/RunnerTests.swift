import Flutter
import XCTest

@testable import rudder_sdk_flutter

final class InstanceListTests: XCTestCase {
    private final class Instance {}

    private var stopped: [Instance] = []
    private let stoppedLock = NSLock()
    private var list: InstanceList<Instance>!
    private let engine1 = NSObject()
    private let engine2 = NSObject()
    private let key = "write-key"

    override func setUp() {
        super.setUp()
        list = InstanceList { [unowned self] instance in
            stoppedLock.lock()
            stopped.append(instance)
            stoppedLock.unlock()
        }
    }

    private func attachment(_ engine: NSObject, _ id: String) -> Attachment { Attachment(engine: engine, id: id) }

    private func mustAttach() -> Instance {
        XCTFail("must attach to the running instance")
        return Instance()
    }

    func testSecondEngineAttachesAndLastDartShutdownStopsTheInstance() {
        let first = Instance()
        XCTAssertFalse(list.create(writeKey: key, attachment: attachment(engine1, "a")) { first })
        XCTAssertTrue(list.create(writeKey: key, attachment: attachment(engine2, "b"), make: mustAttach))

        list.detach(writeKey: key, attachment: attachment(engine2, "b"))
        XCTAssertTrue(list.find(writeKey: key) === first)
        XCTAssertTrue(stopped.isEmpty)

        list.detach(writeKey: key, attachment: attachment(engine1, "a"))
        XCTAssertNil(list.find(writeKey: key))
        XCTAssertTrue(stopped.count == 1 && stopped[0] === first)

        let second = Instance()
        XCTAssertFalse(list.create(writeKey: key, attachment: attachment(engine1, "c")) { second })
        XCTAssertTrue(list.find(writeKey: key) === second)
    }

    func testHandedOverInstanceNeverStopsFromDartAndASecondHandoverIsRefused() {
        let native = Instance()
        XCTAssertTrue(list.handOver(writeKey: key, instance: native))
        XCTAssertTrue(list.handOver(writeKey: key, instance: native))
        XCTAssertFalse(list.handOver(writeKey: key, instance: Instance()))
        XCTAssertTrue(list.create(writeKey: key, attachment: attachment(engine1, "a"), make: mustAttach))
        XCTAssertTrue(list.create(writeKey: key, attachment: attachment(engine2, "b"), make: mustAttach))

        list.detach(writeKey: key, attachment: attachment(engine1, "a"))
        list.detach(writeKey: key, attachment: attachment(engine2, "b"))
        list.detachEngine(engine1)

        XCTAssertTrue(list.find(writeKey: key) === native)
        XCTAssertTrue(stopped.isEmpty)
    }

    func testHandoverAfterDartCreatedTheInstanceIsRefused() {
        let dart = Instance()
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a")) { dart }

        XCTAssertFalse(list.handOver(writeKey: key, instance: Instance()))
        XCTAssertTrue(list.find(writeKey: key) === dart)
    }

    func testEngineThatGoesAwayDropsOnlyItsOwnAttachments() {
        let shared = Instance()
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a")) { shared }
        _ = list.create(writeKey: key, attachment: attachment(engine2, "b"), make: mustAttach)
        _ = list.create(writeKey: key, attachment: attachment(engine2, "c"), make: mustAttach)

        list.detachEngine(engine2)
        XCTAssertTrue(list.find(writeKey: key) === shared)
        XCTAssertTrue(stopped.isEmpty)

        list.detach(writeKey: key, attachment: attachment(engine1, "a"))
        XCTAssertTrue(stopped.count == 1 && stopped[0] === shared)
    }

    func testLastEngineGoingAwayWithoutShutdownKeepsTheInstanceForANewEngine() {
        let orphan = Instance()
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a")) { orphan }
        list.detachEngine(engine1)

        XCTAssertTrue(list.find(writeKey: key) === orphan)
        XCTAssertTrue(list.create(writeKey: key, attachment: attachment(engine2, "b"), make: mustAttach))
        list.detach(writeKey: key, attachment: attachment(engine2, "b"))
        XCTAssertTrue(stopped.count == 1 && stopped[0] === orphan)
    }

    func testShutdownAndThenEngineGoingAwayRemoveTheAttachmentOnce() {
        let shared = Instance()
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a")) { shared }
        _ = list.create(writeKey: key, attachment: attachment(engine2, "b"), make: mustAttach)

        list.detach(writeKey: key, attachment: attachment(engine2, "b"))
        list.detachEngine(engine2)
        list.detach(writeKey: key, attachment: attachment(engine2, "b"))

        XCTAssertTrue(stopped.isEmpty)
        list.detach(writeKey: key, attachment: attachment(engine1, "a"))
        XCTAssertEqual(stopped.count, 1)
    }

    func testDetachForUnknownKeyOrAttachmentChangesNothing() {
        let only = Instance()
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a")) { only }

        list.detach(writeKey: "other-key", attachment: attachment(engine1, "a"))
        list.detach(writeKey: key, attachment: attachment(engine1, "unknown"))
        list.detach(writeKey: key, attachment: attachment(engine2, "a"))

        XCTAssertTrue(list.find(writeKey: key) === only)
        XCTAssertTrue(stopped.isEmpty)
    }

    func testFailedStartAddsNothingAndALaterCreateStartsTheInstance() {
        struct StartFailure: Error {}
        XCTAssertThrowsError(try list.create(writeKey: key, attachment: attachment(engine1, "a")) { throw StartFailure() })
        XCTAssertNil(list.find(writeKey: key))

        let retry = Instance()
        XCTAssertFalse(list.create(writeKey: key, attachment: attachment(engine1, "a")) { retry })
        XCTAssertTrue(list.find(writeKey: key) === retry)
    }

    func testWriteKeysAreIndependent() {
        let first = Instance()
        let second = Instance()
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a")) { first }
        _ = list.create(writeKey: "other-key", attachment: attachment(engine1, "a")) { second }

        list.detach(writeKey: key, attachment: attachment(engine1, "a"))

        XCTAssertTrue(stopped.count == 1 && stopped[0] === first)
        XCTAssertTrue(list.find(writeKey: "other-key") === second)
    }

    func testParallelCreatesAndShutdownsStopEveryInstanceThatTheyCreated() {
        var created: [Instance] = []
        let createdLock = NSLock()
        DispatchQueue.concurrentPerform(iterations: 8) { thread in
            for round in 0..<200 {
                let attachment = attachment(engine1, "\(thread)-\(round)")
                _ = list.create(writeKey: key, attachment: attachment) {
                    let instance = Instance()
                    createdLock.lock()
                    created.append(instance)
                    createdLock.unlock()
                    return instance
                }
                list.detach(writeKey: key, attachment: attachment)
            }
        }

        XCTAssertNil(list.find(writeKey: key))
        XCTAssertEqual(Set(created.map(ObjectIdentifier.init)), Set(stopped.map(ObjectIdentifier.init)))
        XCTAssertEqual(created.count, stopped.count)
    }
}

final class ConversionTests: XCTestCase {
    func testBooleanNumbersBecomeSwiftBoolsAndOtherNumbersStayNumbers() throws {
        let converted = try sdkValue([
            "true": NSNumber(value: true),
            "false": NSNumber(value: false),
            "one": NSNumber(value: 1),
            "zero": NSNumber(value: 0),
            "double": NSNumber(value: 2.5),
            "nested": ["flag": NSNumber(value: true), "list": [NSNumber(value: false), NSNumber(value: 1)]],
        ] as [String: Any]) as! [String: Any]

        // The SDK encoder checks `as? Int` first. A boolean NSNumber passes that check, and a Swift Bool does not.
        XCTAssertEqual(converted["true"] as? Bool, true)
        XCTAssertNil(converted["true"] as? Int)
        XCTAssertEqual(converted["false"] as? Bool, false)
        XCTAssertNil(converted["false"] as? Int)
        XCTAssertEqual(converted["one"] as? Int, 1)
        XCTAssertEqual(converted["zero"] as? Int, 0)
        XCTAssertEqual(converted["double"] as? Double, 2.5)
        let nested = converted["nested"] as! [String: Any]
        XCTAssertNil(nested["flag"] as? Int)
        let list = nested["list"] as! [Any]
        XCTAssertNil(list[0] as? Int)
        XCTAssertEqual(list[1] as? Int, 1)
    }

    func testTypedDataBecomesAListOfNumbers() throws {
        let bytes = FlutterStandardTypedData(bytes: Data([0, 1, 255]))
        XCTAssertEqual(try sdkValue(bytes) as? [Int], [0, 1, 255])
    }

    func testNegativeNumberIsRejectedWhereTheSdkNeedsAnUnsignedNumber() throws {
        let arguments: [String: Any] = ["negative": NSNumber(value: -5), "positive": NSNumber(value: 1_234_567_890_123)]
        XCTAssertThrowsError(try arguments.uint64("negative"))
        XCTAssertEqual(try arguments.uint64("positive"), 1_234_567_890_123)
    }
}
