import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_integration_appcenter_flutter/rudder_integration_appcenter_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('rudder_integration_appcenter_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await RudderIntegrationAppcenterFlutter.platformVersion, '42');
  });
}
