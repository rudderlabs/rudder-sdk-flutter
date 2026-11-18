import 'package:flutter/material.dart';
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

const _writeKey = String.fromEnvironment(
  'WRITE_KEY',
  defaultValue: '<write key>',
);
const _dataPlaneUrl = String.fromEnvironment(
  'DATA_PLANE_URL',
  defaultValue: '<data plane URL>',
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final analytics = Analytics(
    Configuration(
      writeKey: _writeKey,
      dataPlaneUrl: _dataPlaneUrl,
      logLevel: LogLevel.info,
    ),
  );
  runApp(MaterialApp(home: DemoScreen(analytics: analytics)));
}

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key, required this.analytics});

  final Analytics analytics;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('RudderStack Flutter SDK')),
    body: ListView(
      children: [
        ListTile(
          title: const Text('Identify'),
          onTap: () =>
              analytics.identify(userId: 'user-1', traits: {'plan': 'gold'}),
        ),
        ListTile(
          title: const Text('Track'),
          onTap: () => analytics.track(
            'Order Completed',
            properties: {'revenue': 30.5, 'currency': 'USD'},
          ),
        ),
        ListTile(
          title: const Text('Screen'),
          onTap: () => analytics.screen('Home', category: 'Main'),
        ),
        ListTile(title: const Text('Flush'), onTap: analytics.flush),
        ListTile(title: const Text('Reset'), onTap: analytics.reset),
      ],
    ),
  );
}
