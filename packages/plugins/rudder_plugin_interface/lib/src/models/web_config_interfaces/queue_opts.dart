class BatchOpts {
  final bool enabled;
  final int? maxItems;
  final int? maxSize;
  final int? flushInterval;

  BatchOpts({
    required this.enabled,
    this.maxItems,
    this.maxSize,
    this.flushInterval,
  });

  // Method to convert the BatchOpts object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'maxItems': maxItems,
      'maxSize': maxSize,
      'flushInterval': flushInterval,
    };
  }
}

class QueueOpts {
  final int? maxRetryDelay;
  final int? minRetryDelay;
  final double? backoffFactor;
  final double? backoffJitter;
  final int? maxAttempts;
  final int? maxItems;
  final BatchOpts? batch;
  final double? timerScaleFactor;

  QueueOpts({
    this.maxRetryDelay,
    this.minRetryDelay,
    this.backoffFactor,
    this.backoffJitter,
    this.maxAttempts,
    this.maxItems,
    this.batch,
    this.timerScaleFactor,
  });

  // Method to convert QueueOpts object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'maxRetryDelay': maxRetryDelay,
      'minRetryDelay': minRetryDelay,
      'backoffFactor': backoffFactor,
      'backoffJitter': backoffJitter,
      'maxAttempts': maxAttempts,
      'maxItems': maxItems,
      'batch':
          batch?.toMap(), // Convert the batch object to a map if it's not null
      'timerScaleFactor': timerScaleFactor,
    };
  }
}
