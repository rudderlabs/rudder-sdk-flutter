import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_sdk_flutter/RudderClient.dart';
import 'package:rudder_sdk_flutter/RudderController.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_sdk_flutter_platform_interface/rudder_sdk_platform.dart';

class AliasRecordingPlatform extends RudderSdkPlatform {
  String? newId;
  String? previousId;
  RudderOption? options;
  String? invokedMethod;

  @override
  void alias(String newId, {RudderOption? options}) {
    this.newId = newId;
    this.options = options;
    invokedMethod = 'alias';
  }

  @override
  void aliasWithPreviousId(String newId, String previousId,
      {RudderOption? options}) {
    this.newId = newId;
    this.previousId = previousId;
    this.options = options;
    invokedMethod = 'aliasWithPreviousId';
  }
}

class LegacyAliasPlatform extends RudderSdkPlatform {
  @override
  void alias(String newId, {RudderOption? options}) {}
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
    expect(platform.invokedMethod, 'aliasWithPreviousId');
  });

  test('controller keeps previousId optional', () {
    RudderController.instance.alias('new-id');

    expect(platform.newId, 'new-id');
    expect(platform.previousId, isNull);
    expect(platform.invokedMethod, 'alias');
  });

  test('legacy client forwards an explicit previousId', () {
    RudderClient.alias('new-id', previousId: 'previous-id');

    expect(platform.newId, 'new-id');
    expect(platform.previousId, 'previous-id');
    expect(platform.invokedMethod, 'aliasWithPreviousId');
  });

  test('platform default rejects an unsupported explicit previousId', () {
    expect(
      () => LegacyAliasPlatform().aliasWithPreviousId(
        'new-id',
        'previous-id',
      ),
      throwsUnsupportedError,
    );
  });
}
