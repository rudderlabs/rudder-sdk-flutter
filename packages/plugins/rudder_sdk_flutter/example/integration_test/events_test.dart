import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';
import 'package:rudder_sdk_flutter_example/second_engine.dart';

import 'support/mock_data_plane.dart';
import 'support/test_host.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MockDataPlane server;

  setUpAll(() async => server = await MockDataPlane.start());
  tearDownAll(() => server.stop());

  Analytics analyticsFor(String writeKey) =>
      Analytics(testConfiguration(writeKey, server.url));

  testWidgets('every event type arrives with its fields and options', (
    tester,
  ) async {
    final writeKey = uniqueWriteKey('shape');
    final analytics = analyticsFor(writeKey);
    const options = RudderOption(
      integrations: {'Amplitude': false},
      customContext: {'campaign': 'spring'},
      externalIds: [ExternalId(type: 'brazeExternalId', id: 'braze-1')],
    );

    analytics.track(
      'Order Completed',
      properties: {'revenue': 30.5, 'currency': 'USD'},
      options: options,
    );
    analytics.screen('Checkout', category: 'Shop', properties: {'step': 2});
    analytics.group('team-1', traits: {'plan': 'pro'}, options: options);
    analytics.identify(
      userId: 'user-1',
      traits: {'email': 'user@example.com'},
      options: options,
    );
    analytics.alias('user-2', options: options);
    final anonymousId = await analytics.anonymousId;

    final events = await server.waitForEvents(writeKey, (_) => true, count: 5);
    expect(events.map(describe), [
      'track:Order Completed',
      'screen:Checkout',
      'group',
      'identify',
      'alias',
    ]);
    for (final event in events) {
      expect(event['anonymousId'], anonymousId);
      expect(event['messageId'], isA<String>());
      expect(
        event['context'],
        allOf(
          contains('app'),
          contains('device'),
          contains('library'),
          contains('os'),
        ),
      );
    }
    for (final event in [events[0], events[2], events[3], events[4]]) {
      expect(event['integrations'], {'All': true, 'Amplitude': false});
      expect(event['context']['campaign'], 'spring');
      expect(event['context']['externalId'], [
        {'type': 'brazeExternalId', 'id': 'braze-1'},
      ]);
    }
    expect(events[0]['properties'], {'revenue': 30.5, 'currency': 'USD'});
    expect(events[1]['event'], 'Checkout');
    expect(events[1]['properties'], {
      'name': 'Checkout',
      'category': 'Shop',
      'step': 2,
    });
    expect(events[2]['groupId'], 'team-1');
    expect(events[2]['traits'], {'plan': 'pro'});
    expect(events[3]['userId'], 'user-1');
    expect(
      events[3]['context']['traits'],
      containsPair('email', 'user@example.com'),
    );
    expect(events[4]['userId'], 'user-2');
    expect(events[4]['previousId'], 'user-1');
    await analytics.shutdown();
  });

  testWidgets(
    'each value type keeps its JSON type in properties, traits and custom context',
    (tester) async {
      final writeKey = uniqueWriteKey('values');
      final analytics = analyticsFor(writeKey);
      final values = <String, Object?>{
        'int': 42,
        'negative': -7,
        'beyondDoublePrecision': 9007199254740993,
        'double': 3.5,
        'true': true,
        'false': false,
        'null': null,
        'text': 'naïve café ✓ 日本',
        'emptyText': '',
        'list': [1, 'two', true, false, null, 2.5],
        'map': {
          'deep': {'level': 3, 'flag': true, 'off': false},
        },
        'emptyMap': <String, Object?>{},
        'emptyList': <Object?>[],
        'bytes': Uint8List.fromList([0, 1, 255]),
      };
      final expected = {
        ...values,
        'bytes': [0, 1, 255],
      };

      analytics.track(
        'Values',
        properties: values,
        options: RudderOption(customContext: {'values': values}),
      );
      analytics.identify(userId: 'user-1', traits: values);

      final track = await server.waitForTrack(writeKey, 'Values');
      expect(track['properties'], expected);
      expect(track['context']['values'], expected);
      final identify = (await server.waitForEvents(
        writeKey,
        (event) => event['type'] == 'identify',
      )).single;
      expect(
        Map.of(identify['context']['traits'] as Map)..remove('userId'),
        expected,
      );
      expect(await analytics.traits, expected);
      await analytics.shutdown();
    },
  );

  testWidgets('identify, the getters and reset keep the user identity right', (
    tester,
  ) async {
    final writeKey = uniqueWriteKey('identity');
    final analytics = analyticsFor(writeKey);
    final firstAnonymousId = await analytics.anonymousId;
    expect(firstAnonymousId, isNotEmpty);
    expect(await analytics.userId, anyOf(isNull, isEmpty));

    analytics.identify(
      userId: 'user-1',
      traits: {'plan': 'free', 'email': 'user@example.com'},
    );
    analytics.identify(traits: {'plan': 'pro'});
    expect(await analytics.userId, 'user-1');
    expect(
      await analytics.traits,
      allOf(
        containsPair('plan', 'pro'),
        containsPair('email', 'user@example.com'),
      ),
    );
    analytics.track('After Traits Only');

    analytics.reset(
      const ResetOptions(entries: ResetEntries(anonymousId: false)),
    );
    expect(await analytics.userId, anyOf(isNull, isEmpty));
    expect(await analytics.anonymousId, firstAnonymousId);
    analytics.track('After Partial Reset');

    analytics.identify(userId: 'user-2');
    analytics.identify(userId: 'user-3', traits: {'tier': 'gold'});
    analytics.track('As User 3');
    analytics.reset();
    final secondAnonymousId = await analytics.anonymousId;
    expect(secondAnonymousId, isNot(firstAnonymousId));
    analytics.track('After Full Reset');

    final traitsOnly = await server.waitForTrack(writeKey, 'After Traits Only');
    expect(traitsOnly['userId'], 'user-1');
    expect(
      traitsOnly['context']['traits'],
      allOf(
        containsPair('plan', 'pro'),
        containsPair('email', 'user@example.com'),
      ),
    );
    final partial = await server.waitForTrack(writeKey, 'After Partial Reset');
    expect(partial['anonymousId'], firstAnonymousId);
    expect(partial['userId'], anyOf(isNull, isEmpty));
    final user3 = await server.waitForTrack(writeKey, 'As User 3');
    expect(user3['userId'], 'user-3');
    expect(user3['context']['traits'], isNot(contains('plan')));
    final full = await server.waitForTrack(writeKey, 'After Full Reset');
    expect(full['anonymousId'], secondAnonymousId);
    expect(full['userId'], anyOf(isNull, isEmpty));
    await analytics.shutdown();
  });

  testWidgets('manual sessions reach the native SDK and the session getter', (
    tester,
  ) async {
    final writeKey = uniqueWriteKey('sessions');
    final analytics = analyticsFor(writeKey);

    analytics.startSession(sessionId: 1234567890123);
    expect(await analytics.sessionId, 1234567890123);
    analytics.track('In Manual Session');
    // The native SDKs read the session when they process an event, so the test waits for each event.
    final inSession = await server.waitForTrack(writeKey, 'In Manual Session');
    expect(inSession['context']['sessionId'], 1234567890123);
    analytics.startSession(sessionId: 123);
    analytics.startSession(sessionId: -5);
    expect(await analytics.sessionId, 1234567890123);
    analytics.endSession();
    expect(await analytics.sessionId, isNull);
    analytics.track('After End Session');
    final after = await server.waitForTrack(writeKey, 'After End Session');
    expect(after['context'], isNot(contains('sessionId')));
    analytics.startSession();
    expect(
      await analytics.sessionId,
      isA<int>().having(
        (id) => id.toString().length,
        'digits',
        greaterThanOrEqualTo(10),
      ),
    );

    await analytics.shutdown();
  });

  testWidgets(
    'two write keys keep their instances, identities and events apart',
    (tester) async {
      final firstKey = uniqueWriteKey('first');
      final secondKey = uniqueWriteKey('second');
      final first = analyticsFor(firstKey);
      final second = analyticsFor(secondKey);

      first.identify(userId: 'first-user');
      first.track('First Event');
      second.track('Second Event');

      final firstEvents = await server.waitForEvents(
        firstKey,
        (_) => true,
        count: 2,
      );
      final secondEvents = await server.waitForEvents(secondKey, (_) => true);
      expect(firstEvents.map(describe), ['identify', 'track:First Event']);
      expect(secondEvents.map(describe), ['track:Second Event']);
      expect(secondEvents.single['userId'], anyOf(isNull, isEmpty));
      expect(await first.anonymousId, isNot(await second.anonymousId));

      await first.shutdown();
      second.track('Second Still Works');
      await server.waitForTrack(secondKey, 'Second Still Works');
      final again = analyticsFor(firstKey);
      expect(await again.userId, 'first-user');
      await again.shutdown();
      await second.shutdown();
    },
  );

  testWidgets(
    'every event carries the Flutter wrapper library, on the Dart path and the native path',
    (tester) async {
      final dartKey = uniqueWriteKey('wrapper-dart');
      final nativeKey = uniqueWriteKey('wrapper-native');
      final dart = Analytics(
        testConfiguration(
          dartKey,
          server.url,
          trackApplicationLifecycleEvents: true,
        ),
      );
      dart.track('Dart');
      await startNativeInstance(nativeKey, server.url);
      await nativeTrack(nativeKey, 'Native');
      await server.waitForTrack(dartKey, 'Application Installed');
      await server.waitForTrack(dartKey, 'Dart');
      await server.waitForTrack(nativeKey, 'Native');

      final events = [...server.events(dartKey), ...server.events(nativeKey)];
      for (final event in events) {
        final context = event['context'] as Map<String, dynamic>;
        final wrapper = context['wrapperLibrary'] as Map<String, dynamic>?;
        final library = context['library'] as Map<String, dynamic>;
        expect(wrapper?['name'], 'rudder-sdk-flutter', reason: describe(event));
        expect(
          wrapper?['version'],
          isNot(anyOf(isNull, isEmpty, library['version'])),
        );
        expect(library['name'], isNot('rudder-sdk-flutter'));
      }

      await dart.shutdown();
      await stopNativeInstance(nativeKey);
    },
  );

  testWidgets(
    'a new instance adds each listed integration once, and an unknown name does not stop the SDK',
    (tester) async {
      final writeKey = uniqueWriteKey('integrations');
      final analytics = Analytics(
        testConfiguration(
          writeKey,
          server.url,
          integrations: const [
            _NamedIntegration('missing'),
            _NamedIntegration('flutter_test'),
            _NamedIntegration('flutter_test'),
          ],
        ),
      );
      // The integration gets events only after the SDK has loaded the source config.
      var ready = false;
      for (var attempt = 0; attempt < 20 && !ready; attempt++) {
        await analytics.track('$writeKey warm-up');
        await Future<void>.delayed(const Duration(milliseconds: 500));
        ready = (await integrationEvents()).contains('$writeKey warm-up');
      }
      expect(ready, isTrue);

      await analytics.track('$writeKey checked');
      await server.waitForTrack(writeKey, '$writeKey checked');
      await Future<void>.delayed(const Duration(seconds: 1));
      expect(
        (await integrationEvents()).where(
          (name) => name == '$writeKey checked',
        ),
        hasLength(1),
      );
      await analytics.shutdown();
    },
  );
}

class _NamedIntegration extends Integration {
  const _NamedIntegration(super.name);
}
