import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';
import 'package:rudder_sdk_flutter_example/second_engine.dart';

import 'support/mock_data_plane.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MockDataPlane server;

  setUpAll(() async => server = await MockDataPlane.start());
  tearDownAll(() => server.stop());
  setUp(() => server.sourceEnabled = true);

  testWidgets('uploads carry the write key, and gzip follows the setting', (
    tester,
  ) async {
    final gzipKey = uniqueWriteKey('gzip-on');
    final plainKey = uniqueWriteKey('gzip-off');
    final gzipped = Analytics(
      testConfiguration(gzipKey, server.url, gzipEnabled: true),
    );
    final plain = Analytics(testConfiguration(plainKey, server.url));

    gzipped.track('Gzipped');
    plain.track('Plain');
    await server.waitForTrack(gzipKey, 'Gzipped');
    await server.waitForTrack(plainKey, 'Plain');

    expect(
      server.uploads(gzipKey).map((upload) => upload.gzipped),
      everyElement(isTrue),
    );
    expect(
      server.uploads(plainKey).map((upload) => upload.gzipped),
      everyElement(isFalse),
    );
    await gzipped.shutdown();
    await plain.shutdown();
  });

  testWidgets(
    'a count flush policy batches events, and flush uploads the rest at once',
    (tester) async {
      final writeKey = uniqueWriteKey('batch');
      final analytics = Analytics(
        testConfiguration(
          writeKey,
          server.url,
          flushPolicies: const [CountFlushPolicy(flushAt: 3)],
        ),
      );

      analytics.track('Batched 1');
      analytics.track('Batched 2');
      expect(
        await server.eventsAfter(writeKey, const Duration(seconds: 3)),
        isEmpty,
      );
      analytics.track('Batched 3');
      await server.waitForEvents(writeKey, (_) => true, count: 3);
      expect(
        server
            .uploads(writeKey)
            .map((upload) => (upload.body['batch'] as List).length),
        [3],
      );

      analytics.track('Batched 4');
      expect(
        await server.eventsAfter(writeKey, const Duration(seconds: 3)),
        hasLength(3),
      );
      await analytics.flush();
      final events = await server.waitForEvents(
        writeKey,
        (_) => true,
        count: 4,
      );
      expect(events.map(describe), [
        'track:Batched 1',
        'track:Batched 2',
        'track:Batched 3',
        'track:Batched 4',
      ]);
      await analytics.shutdown();
    },
  );

  testWidgets('a disabled source sends nothing', (tester) async {
    server.sourceEnabled = false;
    final writeKey = uniqueWriteKey('disabled');
    final analytics = Analytics(testConfiguration(writeKey, server.url));
    await Future<void>.delayed(const Duration(seconds: 3));

    analytics.track('Should Not Arrive');
    await analytics.flush();

    expect(
      await server.eventsAfter(writeKey, const Duration(seconds: 5)),
      isEmpty,
    );
    await analytics.shutdown();
  });

  testWidgets(
    'the consent from the configuration reaches events, and setConsent changes it',
    (tester) async {
      final writeKey = uniqueWriteKey('consent');
      final analytics = Analytics(
        testConfiguration(
          writeKey,
          server.url,
          consentManagement: const ConsentManagementConfiguration(
            enabled: true,
            allowedConsentIds: ['analytics'],
            deniedConsentIds: ['ads'],
          ),
        ),
      );

      analytics.track('Before Change');
      final before = await server.waitForTrack(writeKey, 'Before Change');
      analytics.setConsent(
        const ConsentManagementOptions(allowedConsentIds: ['analytics', 'ads']),
      );
      analytics.track('After Change');
      final after = await server.waitForTrack(writeKey, 'After Change');

      expect(
        before['context']['consentManagement'],
        containsPair('deniedConsentIds', ['ads']),
      );
      expect(
        after['context']['consentManagement'],
        containsPair('deniedConsentIds', isEmpty),
      );
      expect(
        after['context']['consentManagement']['allowedConsentIds'],
        containsAll(['analytics', 'ads']),
      );
      await analytics.shutdown();
    },
  );
}
