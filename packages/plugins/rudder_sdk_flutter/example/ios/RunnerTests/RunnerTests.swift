import Flutter
import XCTest

@testable import rudder_sdk_flutter

final class InstanceListTests: XCTestCase {
    private final class Instance {
        let name: String
        init(_ name: String) { self.name = name }
    }

    // Stands in for the SDK registry: a started instance registers itself, and a stopped one leaves.
    private var running: [String: Instance] = [:]
    private var stopped: [Instance] = []
    private let lock = NSLock()
    private var list: InstanceList<Instance>!
    private let engine1 = NSObject()
    private let engine2 = NSObject()
    private let key = "write-key"

    override func setUp() {
        super.setUp()
        list = makeList()
    }

    private func makeList(beforeStop: @escaping (Instance) -> Void = { _ in }) -> InstanceList<Instance> {
        InstanceList(findRunning: { [unowned self] key in locked { running[key] } }) { [unowned self] instance in
            beforeStop(instance)
            locked {
                running = running.filter { $0.value !== instance }
                stopped.append(instance)
            }
        }
    }

    private func locked<T>(_ body: () -> T) -> T {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    private func starts(_ name: String, key: String? = nil) -> () -> Instance {
        { [unowned self] in
            let instance = Instance(name)
            locked { running[key ?? self.key] = instance }
            return instance
        }
    }

    private func nativeStarts(_ name: String) -> Instance { starts(name)() }

    private func nativeStops() { locked { running[key] = nil } }

    private func attachment(_ engine: NSObject, _ id: String) -> Attachment { Attachment(engine: engine, id: id) }

    private func mustAttach() -> Instance {
        XCTFail("must attach to the running instance")
        return Instance("unexpected")
    }

    func testSecondEngineAttachesAndLastDartShutdownStopsTheInstance() {
        XCTAssertFalse(list.create(writeKey: key, attachment: attachment(engine1, "a"), make: starts("first")))
        let first = list.find(writeKey: key)
        XCTAssertTrue(list.create(writeKey: key, attachment: attachment(engine2, "b"), make: mustAttach))

        list.detach(writeKey: key, attachment: attachment(engine2, "b"))
        XCTAssertTrue(list.find(writeKey: key) === first)
        XCTAssertTrue(stopped.isEmpty)

        list.detach(writeKey: key, attachment: attachment(engine1, "a"))
        XCTAssertNil(list.find(writeKey: key))
        XCTAssertTrue(stopped.count == 1 && stopped[0] === first)

        XCTAssertFalse(list.create(writeKey: key, attachment: attachment(engine1, "c"), make: starts("second")))
        XCTAssertEqual(list.find(writeKey: key)?.name, "second")
    }

    func testInstanceThatNativeCodeStartedNeverStopsFromDart() {
        let native = nativeStarts("native")
        XCTAssertTrue(list.create(writeKey: key, attachment: attachment(engine1, "a"), make: mustAttach))
        XCTAssertTrue(list.create(writeKey: key, attachment: attachment(engine2, "b"), make: mustAttach))

        list.detach(writeKey: key, attachment: attachment(engine1, "a"))
        list.detach(writeKey: key, attachment: attachment(engine2, "b"))
        list.detachEngine(engine1)

        XCTAssertTrue(list.find(writeKey: key) === native)
        XCTAssertTrue(stopped.isEmpty)
        XCTAssertTrue(list.create(writeKey: key, attachment: attachment(engine1, "c"), make: mustAttach))
    }

    func testAfterNativeCodeStopsItsInstanceTheNextCreateStartsOneThatEveryAttachmentShares() {
        _ = nativeStarts("native")
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a"), make: mustAttach)
        nativeStops()

        XCTAssertFalse(list.create(writeKey: key, attachment: attachment(engine2, "b"), make: starts("dart")))
        let dart = list.find(writeKey: key)
        XCTAssertEqual(dart?.name, "dart")

        list.detach(writeKey: key, attachment: attachment(engine2, "b"))
        XCTAssertTrue(stopped.isEmpty)
        list.detach(writeKey: key, attachment: attachment(engine1, "a"))
        XCTAssertTrue(stopped.count == 1 && stopped[0] === dart)
    }

    func testAfterNativeCodeReplacesItsInstanceTheNextCreateAttachesToTheNewOneAndNeverStopsIt() {
        _ = nativeStarts("old")
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a"), make: mustAttach)
        nativeStops()
        let replacement = nativeStarts("new")

        XCTAssertTrue(list.create(writeKey: key, attachment: attachment(engine2, "b"), make: mustAttach))
        XCTAssertTrue(list.find(writeKey: key) === replacement)

        list.detach(writeKey: key, attachment: attachment(engine1, "a"))
        list.detach(writeKey: key, attachment: attachment(engine2, "b"))
        XCTAssertTrue(stopped.isEmpty)
    }

    func testAfterNativeCodeReplacesItsInstanceCallsOfAnAttachedDartObjectGoToTheNewOne() {
        _ = nativeStarts("old")
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a"), make: mustAttach)
        nativeStops()
        let replacement = nativeStarts("new")

        XCTAssertTrue(list.find(writeKey: key) === replacement)
        list.detach(writeKey: key, attachment: attachment(engine1, "a"))
        XCTAssertTrue(stopped.isEmpty)
    }

    func testWhenNativeCodeStartsAnInstanceWhileDartStartsOneDartUsesTheNativeOne() {
        var native: Instance?
        let attached = list.create(writeKey: key, attachment: attachment(engine1, "a")) {
            native = nativeStarts("native")
            return Instance("refused")
        }

        XCTAssertTrue(attached)
        XCTAssertTrue(list.find(writeKey: key) === native)
        list.detach(writeKey: key, attachment: attachment(engine1, "a"))
        XCTAssertTrue(stopped.isEmpty)
    }

    func testCreateOnAnotherThreadWhileTheLastShutdownStopsTheInstanceStartsANewInstance() {
        var racing: InstanceList<Instance>!
        let created = DispatchSemaphore(value: 0)
        racing = makeList { [unowned self] _ in
            DispatchQueue.global().async {
                _ = racing.create(writeKey: self.key, attachment: self.attachment(self.engine2, "b"), make: self.starts("next"))
                created.signal()
            }
            _ = created.wait(timeout: .now() + .milliseconds(200))
        }
        _ = racing.create(writeKey: key, attachment: attachment(engine1, "a"), make: starts("first"))

        racing.detach(writeKey: key, attachment: attachment(engine1, "a"))
        created.wait()

        XCTAssertEqual(racing.find(writeKey: key)?.name, "next")
    }

    func testEngineThatGoesAwayDropsOnlyItsOwnAttachments() {
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a"), make: starts("shared"))
        let shared = list.find(writeKey: key)
        _ = list.create(writeKey: key, attachment: attachment(engine2, "b"), make: mustAttach)
        _ = list.create(writeKey: key, attachment: attachment(engine2, "c"), make: mustAttach)

        list.detachEngine(engine2)
        XCTAssertTrue(list.find(writeKey: key) === shared)
        XCTAssertTrue(stopped.isEmpty)

        list.detach(writeKey: key, attachment: attachment(engine1, "a"))
        XCTAssertTrue(stopped.count == 1 && stopped[0] === shared)
    }

    func testLastEngineGoingAwayWithoutShutdownKeepsTheInstanceForANewEngine() {
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a"), make: starts("orphan"))
        let orphan = list.find(writeKey: key)
        list.detachEngine(engine1)

        XCTAssertTrue(list.find(writeKey: key) === orphan)
        XCTAssertTrue(list.create(writeKey: key, attachment: attachment(engine2, "b"), make: mustAttach))
        list.detach(writeKey: key, attachment: attachment(engine2, "b"))
        XCTAssertTrue(stopped.count == 1 && stopped[0] === orphan)
    }

    func testShutdownAndThenEngineGoingAwayRemoveTheAttachmentOnce() {
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a"), make: starts("shared"))
        _ = list.create(writeKey: key, attachment: attachment(engine2, "b"), make: mustAttach)

        list.detach(writeKey: key, attachment: attachment(engine2, "b"))
        list.detachEngine(engine2)
        list.detach(writeKey: key, attachment: attachment(engine2, "b"))

        XCTAssertTrue(stopped.isEmpty)
        list.detach(writeKey: key, attachment: attachment(engine1, "a"))
        XCTAssertEqual(stopped.count, 1)
    }

    func testDetachForUnknownKeyOrAttachmentChangesNothing() {
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a"), make: starts("only"))
        let only = list.find(writeKey: key)

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

        XCTAssertFalse(list.create(writeKey: key, attachment: attachment(engine1, "a"), make: starts("retry")))
        XCTAssertEqual(list.find(writeKey: key)?.name, "retry")
    }

    func testWriteKeysAreIndependent() {
        _ = list.create(writeKey: key, attachment: attachment(engine1, "a"), make: starts("first"))
        _ = list.create(writeKey: "other-key", attachment: attachment(engine1, "a"), make: starts("second", key: "other-key"))

        list.detach(writeKey: key, attachment: attachment(engine1, "a"))

        XCTAssertEqual(stopped.map(\.name), ["first"])
        XCTAssertEqual(list.find(writeKey: "other-key")?.name, "second")
    }

    func testParallelCreatesAndShutdownsStopEveryInstanceThatTheyCreated() {
        var created: [Instance] = []
        DispatchQueue.concurrentPerform(iterations: 8) { thread in
            for round in 0..<200 {
                let attachment = attachment(engine1, "\(thread)-\(round)")
                _ = list.create(writeKey: key, attachment: attachment) {
                    let instance = starts("\(thread)-\(round)")()
                    locked { created.append(instance) }
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
