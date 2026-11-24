import 'package:flutter/foundation.dart';

import 'configuration.dart';

/// Prints [message] when [level] is at or above [threshold].
void log(LogLevel threshold, LogLevel level, String message) {
  if (threshold == LogLevel.none || level.index < threshold.index) return;
  debugPrint('Rudder-Flutter: ${level.name.toUpperCase()}: $message');
}
