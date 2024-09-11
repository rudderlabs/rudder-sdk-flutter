class BeaconQueueOpts {
  final int? maxItems;
  final int? flushQueueInterval;

  BeaconQueueOpts({this.maxItems, this.flushQueueInterval});

  // Method to convert the BeaconQueueOpts object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'maxItems': maxItems,
      'flushQueueInterval': flushQueueInterval,
    };
  }
}
