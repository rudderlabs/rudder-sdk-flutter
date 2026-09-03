import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_plugin_ios/rudder_plugin_ios.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('rudder_sdk_flutter');
  late List<MethodCall> calls;

  setUp(() {
    calls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('alias sends previousId to the iOS channel', () async {
    RudderSdkFlutterIos().alias('new-id', previousId: 'previous-id');
    await Future<void>.delayed(Duration.zero);

    expect(calls, hasLength(1));
    expect(calls.single.method, 'alias');
    expect(calls.single.arguments,
        {'newId': 'new-id', 'previousId': 'previous-id'});
  });

  test('alias omits previousId when it is not provided', () async {
    RudderSdkFlutterIos().alias('new-id');
    await Future<void>.delayed(Duration.zero);

    expect(calls.single.arguments, {'newId': 'new-id'});
  });
}
