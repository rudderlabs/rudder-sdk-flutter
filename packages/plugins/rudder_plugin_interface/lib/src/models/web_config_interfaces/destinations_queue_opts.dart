class DestinationsQueueOpts {
  final int? maxItems;

  DestinationsQueueOpts({this.maxItems});

  // Method to convert the DestinationsQueueOpts object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'maxItems': maxItems,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
