import Foundation

/// The Dart attachments of the SDK instance for each write key. `findRunning` returns the running instance, whoever started it.
final class InstanceList<Instance: AnyObject> {
    private let findRunning: (String) -> Instance?
    private let stop: (Instance) -> Void
    private let lock = NSLock()
    private var byWriteKey: [String: Entry] = [:]

    init(findRunning: @escaping (String) -> Instance?, stop: @escaping (Instance) -> Void) {
        self.findRunning = findRunning
        self.stop = stop
    }

    /// Returns `true` when `attachment` attached to a running instance, or `false` after it started one with `make`.
    func create(writeKey: String, attachment: Attachment, make: () throws -> Instance) rethrows -> Bool {
        lock.lock()
        defer { lock.unlock() }
        let known = byWriteKey[writeKey]
        let entry = try findRunning(writeKey).map { use(writeKey: writeKey, running: $0) } ?? start(writeKey: writeKey, make: make)
        entry.attachments.insert(attachment)
        return !entry.startedByDart || entry === known
    }

    private func start(writeKey: String, make: () throws -> Instance) rethrows -> Entry {
        let made = try make()
        // Native code can start an instance for the key while `make` runs. Then the SDK refuses the made one.
        if let native = findRunning(writeKey), native !== made { return use(writeKey: writeKey, running: native) }
        return replace(writeKey: writeKey, with: Entry(made, startedByDart: true))
    }

    /// Returns the entry of `running`. An instance that this list did not start belongs to native code.
    private func use(writeKey: String, running: Instance) -> Entry {
        if let known = byWriteKey[writeKey], known.instance === running { return known }
        return replace(writeKey: writeKey, with: Entry(running, startedByDart: false))
    }

    /// An instance that stopped outside Dart leaves its attachments to the instance that runs now.
    private func replace(writeKey: String, with entry: Entry) -> Entry {
        if let known = byWriteKey[writeKey] { entry.attachments.formUnion(known.attachments) }
        byWriteKey[writeKey] = entry
        return entry
    }

    /// Returns the instance that runs now for `writeKey`, also after native code replaced it.
    func find(writeKey: String) -> Instance? {
        lock.lock()
        defer { lock.unlock() }
        guard let known = byWriteKey[writeKey] else { return nil }
        return findRunning(writeKey).map { use(writeKey: writeKey, running: $0).instance } ?? known.instance
    }

    /// `attachment` lets go of its instance. The instance stops when Dart started it and no attachment is left.
    func detach(writeKey: String, attachment: Attachment) {
        lock.lock()
        defer { lock.unlock() }
        guard let entry = byWriteKey[writeKey], entry.attachments.remove(attachment) != nil, entry.startedByDart, entry.attachments.isEmpty else { return }
        byWriteKey.removeValue(forKey: writeKey)
        // The stop runs under the lock, so a create cannot find the instance while it stops.
        stop(entry.instance)
    }

    /// The Dart objects of `engine` are gone. Their instances keep running, as in a native app.
    func detachEngine(_ engine: AnyObject) {
        lock.lock()
        defer { lock.unlock() }
        let engineId = ObjectIdentifier(engine)
        byWriteKey.values.forEach { entry in entry.attachments = entry.attachments.filter { $0.engine != engineId } }
    }

    /// Dart never stops an instance that native code started.
    private final class Entry {
        let instance: Instance
        let startedByDart: Bool
        var attachments: Set<Attachment> = []

        init(_ instance: Instance, startedByDart: Bool) {
            self.instance = instance
            self.startedByDart = startedByDart
        }
    }
}

/// One Dart `Analytics`: its engine, and the ID that the Dart object sends.
struct Attachment: Hashable {
    let engine: ObjectIdentifier
    let id: String

    init(engine: AnyObject, id: String) {
        self.engine = ObjectIdentifier(engine)
        self.id = id
    }
}
