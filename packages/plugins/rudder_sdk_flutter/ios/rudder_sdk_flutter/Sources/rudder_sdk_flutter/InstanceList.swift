import Foundation

/// One SDK instance for each write key in the process, shared by every Flutter engine and by native code.
final class InstanceList<Instance: AnyObject> {
    private let stop: (Instance) -> Void
    private let lock = NSLock()
    private var byWriteKey: [String: Entry] = [:]

    init(stop: @escaping (Instance) -> Void) {
        self.stop = stop
    }

    /// Returns `true` when an instance for `writeKey` already ran and `attachment` attached to it. Otherwise it adds the instance from `make`.
    func create(writeKey: String, attachment: Attachment, make: () throws -> Instance) rethrows -> Bool {
        lock.lock()
        defer { lock.unlock() }
        if let entry = byWriteKey[writeKey] {
            entry.attachments.insert(attachment)
            return true
        }
        let entry = Entry(try make(), handedOver: false)
        entry.attachments.insert(attachment)
        byWriteKey[writeKey] = entry
        return false
    }

    /// Returns `false` when another instance already runs for `writeKey`, and the list keeps that one.
    func handOver(writeKey: String, instance: Instance) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        guard let running = byWriteKey[writeKey] else {
            byWriteKey[writeKey] = Entry(instance, handedOver: true)
            return true
        }
        return running.instance === instance
    }

    func find(writeKey: String) -> Instance? {
        lock.lock()
        defer { lock.unlock() }
        return byWriteKey[writeKey]?.instance
    }

    /// `attachment` lets go of its instance. The instance stops when Dart created it and no attachment is left.
    func detach(writeKey: String, attachment: Attachment) {
        lock.lock()
        var toStop: Instance?
        if let entry = byWriteKey[writeKey], entry.attachments.remove(attachment) != nil, !entry.handedOver, entry.attachments.isEmpty {
            byWriteKey.removeValue(forKey: writeKey)
            toStop = entry.instance
        }
        lock.unlock()
        toStop.map(stop)
    }

    /// The Dart objects of `engine` are gone. Their instances keep running, as in a native app.
    func detachEngine(_ engine: AnyObject) {
        lock.lock()
        defer { lock.unlock() }
        let engineId = ObjectIdentifier(engine)
        byWriteKey.values.forEach { entry in entry.attachments = entry.attachments.filter { $0.engine != engineId } }
    }

    private final class Entry {
        let instance: Instance
        let handedOver: Bool
        var attachments: Set<Attachment> = []

        init(_ instance: Instance, handedOver: Bool) {
            self.instance = instance
            self.handedOver = handedOver
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
