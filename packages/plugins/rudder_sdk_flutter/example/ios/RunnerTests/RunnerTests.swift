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

final class V3MigrationTests: XCTestCase {
    private let v1User: [String: Any] = [
        "rl_anonymous_id": "anon-1",
        "rl_traits": #"{"anonymousId":"anon-1","userId":"user-1","plan":"gold","age":30}"#,
        "rl_session_id": NSNumber(value: 1_700_000_000),
        "rl_application_version_key": "1.2.0",
        "rl_application_build_key": "12",
        "rl_opt_status": false,
    ]

    private final class FakeV1: V1Store {
        let data: [String: Any]
        let writeKey: String?
        var deleted = false
        init(_ data: [String: Any], writeKey: String?) {
            self.data = data
            self.writeKey = writeKey
        }
        func userData() -> [String: Any] { deleted ? [:] : data }
        func storedWriteKey() -> String? { deleted ? nil : writeKey }
        func delete() { deleted = true }
    }

    private final class FakeSwift: SwiftStores {
        let existing: Set<String>
        let failingWrites: Set<String>
        var written: [String: [String: Any]] = [:]
        init(existing: Set<String> = [], failingWrites: Set<String> = []) {
            self.existing = existing
            self.failingWrites = failingWrites
        }
        func isEmpty(writeKey: String) -> Bool { !existing.contains(writeKey) && written[writeKey] == nil }
        func write(writeKey: String, values: [String: Any]) -> Bool {
            guard !failingWrites.contains(writeKey) else { return false }
            written[writeKey] = values
            return true
        }
    }

    private func migration(_ v1: FakeV1, _ swift: FakeSwift) -> V3Migration { V3Migration(v1: v1, swift: swift) { _ in } }

    func testV1ValuesMapToTheSwiftKeysAndTypesWithoutTheSession() throws {
        let values = swiftStoreValues(v1User)

        XCTAssertEqual(Set(values.keys), ["anonymous_id", "user_id", "traits", "rudder.app_version", "rudder.app_build"])
        XCTAssertEqual(values["anonymous_id"] as? String, "anon-1")
        XCTAssertEqual(values["user_id"] as? String, "user-1")
        let traits = try JSONSerialization.jsonObject(with: Data((values["traits"] as! String).utf8)) as! NSDictionary
        XCTAssertEqual(traits, ["plan": "gold", "age": 30] as NSDictionary)
        XCTAssertEqual(values["rudder.app_version"] as? String, "1.2.0")
        XCTAssertEqual(values["rudder.app_build"] as? Int, 12)

        let older = swiftStoreValues(["rl_anonymous_id": "anon-2", "rl_traits": "not json", "rl_application_build_key": "1.0.3"])
        XCTAssertEqual(older.keys.sorted(), ["anonymous_id", "rudder.app_build"])
        XCTAssertEqual(older["rudder.app_build"] as? Int, 0)
    }

    func testTheWriteKeyComesFromTheCachedSourceConfig() {
        XCTAssertEqual(writeKeyFromServerConfig(#"{"source":{"id":"s","writeKey":"2AbC_de-9","enabled":true}}"#), "2AbC_de-9")
        XCTAssertNil(writeKeyFromServerConfig(#"{"source":{"writeKey":""}}"#))
        XCTAssertNil(writeKeyFromServerConfig("not json"))
    }

    func testWithAStoredWriteKeyTheStartupRunMigratesIntoThatKey() {
        let v1 = FakeV1(v1User, writeKey: "A")
        let swift = FakeSwift()
        let migration = migration(v1, swift)

        migration.runAtStartup()
        migration.runBeforeFirstDartStart(writeKey: "B")

        XCTAssertEqual(Set(swift.written.keys), ["A"])
        XCTAssertEqual(swift.written["A"]?["user_id"] as? String, "user-1")
        XCTAssertTrue(v1.deleted)
    }

    func testWhenTheStartupRunDidNotRunTheFirstDartStartMigratesIntoTheStoredWriteKey() {
        let v1 = FakeV1(v1User, writeKey: "A")
        let swift = FakeSwift()

        migration(v1, swift).runBeforeFirstDartStart(writeKey: "B")

        XCTAssertEqual(Set(swift.written.keys), ["A"])
        XCTAssertTrue(v1.deleted)
    }

    func testAFailedWriteKeepsThe3xDataAndNeverMovesTheUserToAnotherKey() {
        let v1 = FakeV1(v1User, writeKey: "A")
        let swift = FakeSwift(failingWrites: ["A"])
        let migration = migration(v1, swift)
        migration.runAtStartup()
        migration.runBeforeFirstDartStart(writeKey: "B")
        XCTAssertTrue(swift.written.isEmpty)
        XCTAssertFalse(v1.deleted)

        let noKeyV1 = FakeV1(v1User, writeKey: nil)
        let noKeySwift = FakeSwift(failingWrites: ["B"])
        let noKeyMigration = self.migration(noKeyV1, noKeySwift)
        noKeyMigration.runBeforeFirstDartStart(writeKey: "B")
        noKeyMigration.runBeforeFirstDartStart(writeKey: "A")
        XCTAssertTrue(noKeySwift.written.isEmpty)
        XCTAssertFalse(noKeyV1.deleted)
    }

    func testAnExistingSwiftStoreForTheKeyBlocksTheMigration() {
        let v1 = FakeV1(v1User, writeKey: "A")
        let swift = FakeSwift(existing: ["A"])

        migration(v1, swift).runAtStartup()

        XCTAssertTrue(swift.written.isEmpty)
        XCTAssertFalse(v1.deleted)
    }

    func testWithoutAStoredWriteKeyOnlyTheFirstInstanceThatDartStartsGetsTheUser() {
        let v1 = FakeV1(v1User, writeKey: nil)
        let swift = FakeSwift()
        let migration = migration(v1, swift)

        migration.runAtStartup()
        XCTAssertTrue(swift.written.isEmpty)
        migration.runBeforeFirstDartStart(writeKey: "B")
        migration.closeFallback()
        migration.runBeforeFirstDartStart(writeKey: "A")

        XCTAssertEqual(Set(swift.written.keys), ["B"])
        XCTAssertTrue(v1.deleted)
    }

    func testAFirstDartCreateThatFindsANativeInstanceClosesTheFallback() {
        let v1 = FakeV1(v1User, writeKey: nil)
        let swift = FakeSwift()
        let migration = migration(v1, swift)

        migration.runAtStartup()
        migration.closeFallback()
        migration.runBeforeFirstDartStart(writeKey: "B")

        XCTAssertTrue(swift.written.isEmpty)
        XCTAssertFalse(v1.deleted)
    }

    func testA3xUserWhoOptedOutDoesNotMoveAndThe3xDataIsDeleted() {
        var optedOut = v1User
        optedOut["rl_opt_status"] = true
        let v1 = FakeV1(optedOut, writeKey: "A")
        let swift = FakeSwift()
        let migration = migration(v1, swift)
        migration.runAtStartup()
        migration.runBeforeFirstDartStart(writeKey: "A")
        XCTAssertTrue(swift.written.isEmpty)
        XCTAssertTrue(v1.deleted)

        let noKeyV1 = FakeV1(optedOut, writeKey: nil)
        self.migration(noKeyV1, swift).runBeforeFirstDartStart(writeKey: "B")
        XCTAssertTrue(swift.written.isEmpty)
        XCTAssertTrue(noKeyV1.deleted)
    }

    func testAnInstallWithNo3xUserWritesNothing() {
        let v1 = FakeV1(["rl_opt_status": false], writeKey: "A")
        let swift = FakeSwift()
        let migration = migration(v1, swift)

        migration.runAtStartup()
        migration.runBeforeFirstDartStart(writeKey: "A")

        XCTAssertTrue(swift.written.isEmpty)
        XCTAssertFalse(v1.deleted)
    }
}
