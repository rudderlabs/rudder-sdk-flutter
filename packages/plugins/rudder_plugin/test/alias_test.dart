import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_sdk_flutter/RudderClient.dart';
import 'package:rudder_sdk_flutter/RudderController.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_sdk_flutter_platform_interface/rudder_sdk_platform.dart';

class AliasRecordingPlatform extends RudderSdkPlatform {
  String? newId;
  String? previousId;
  RudderOption? options;

  @override
  void alias(String newId, {String? previousId, RudderOption? options}) {
    this.newId = newId;
    this.previousId = previousId;
    this.options = options;
  }
}

void main() {
  late AliasRecordingPlatform platform;

  setUp(() {
    platform = AliasRecordingPlatform();
    RudderSdkPlatform.instance = platform;
  });

  test('controller forwards an explicit previousId', () {
    final options = RudderOption();

    RudderController.instance
        .alias('new-id', previousId: 'previous-id', options: options);

    expect(platform.newId, 'new-id');
    expect(platform.previousId, 'previous-id');
    expect(platform.options, same(options));
  });

  test('controller keeps previousId optional', () {
    RudderController.instance.alias('new-id');

    expect(platform.newId, 'new-id');
    expect(platform.previousId, isNull);
  });

  test('legacy client forwards an explicit previousId', () {
    RudderClient.alias('new-id', previousId: 'previous-id');

    expect(platform.newId, 'new-id');
    expect(platform.previousId, 'previous-id');
  });
}
