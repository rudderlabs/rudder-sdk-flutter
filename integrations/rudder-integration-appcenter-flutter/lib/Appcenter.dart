import 'dart:async';

import 'package:flutter/services.dart';

class Appcenter {
  static const MethodChannel _channel = const MethodChannel('appcenter');

  Appcenter() {
    _channel.invokeMethod('addFactory');
  }

  static String platformversion() {
    return "99";
  }
}
