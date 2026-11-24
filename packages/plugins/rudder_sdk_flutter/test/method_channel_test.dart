import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';
import 'package:rudder_sdk_flutter/src/event.dart';
import 'package:rudder_sdk_flutter/src/platform/method_channel_analytics_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final platform = MethodChannelAnalyticsPlatform();
  final calls = <MethodCall>[];
  final replies = <String, Object?>{};

  setUp(() {
    calls.clear();
    replies.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(MethodChannelAnalyticsPlatform.channel, (
          call,
        ) async {
          calls.add(call);
          return replies[call.method];
        });
  });

  test(
    'every method sends its name, the write key and its arguments',
    () async {
      await platform.flush('k');
      await platform.reset(
        'k',
        const ResetOptions(entries: ResetEntries(traits: false)),
      );
      await platform.startSession('k', null);
      await platform.startSession('k', 1234567890123);
      await platform.endSession('k');
      await platform.setConsent(
        'k',
        const ConsentManagementOptions(deniedConsentIds: ['ads']),
      );
      await platform.shutdown('k', 'a1');
      await platform.anonymousId('k');
      await platform.userId('k');
      await platform.traits('k');
      await platform.sessionId('k');

      expect(calls.map((call) => call.method), [
        'flush',
        'reset',
        'startSession',
        'startSession',
        'endSession',
        'setConsent',
        'shutdown',
        'anonymousId',
        'userId',
        'traits',
        'sessionId',
      ]);
      expect(calls.map((call) => call.arguments), [
        {'writeKey': 'k'},
        {
          'writeKey': 'k',
          'entries': {
            'anonymousId': true,
            'userId': true,
            'traits': false,
            'session': true,
          },
        },
        {'writeKey': 'k', 'sessionId': null},
        {'writeKey': 'k', 'sessionId': 1234567890123},
        {'writeKey': 'k'},
        {
          'writeKey': 'k',
          'allowedConsentIds': <String>[],
          'deniedConsentIds': ['ads'],
        },
        {'writeKey': 'k', 'attachmentId': 'a1'},
        {'writeKey': 'k'},
        {'writeKey': 'k'},
        {'writeKey': 'k'},
        {'writeKey': 'k'},
      ]);
    },
  );

  test(
    'create sends the configuration with the attachment ID and reports an attach',
    () async {
      final configuration = Configuration(
        writeKey: 'k',
        dataPlaneUrl: 'https://dp',
      );
      expect(await platform.create(configuration, 'a1'), isFalse);
      replies['create'] = true;
      expect(await platform.create(configuration, 'a1'), isTrue);

      expect(calls.first.arguments, {
        ...configuration.toMap(),
        'attachmentId': 'a1',
      });
    },
  );

  test('each value type in an event keeps its type on the channel', () async {
    final values = <String, Object?>{
      'int': 42,
      'negative': -7,
      'beyondDoublePrecision': 9007199254740993,
      'double': 10.5,
      'true': true,
      'false': false,
      'null': null,
      'unicode': 'Größe 😀 مرحبا',
      'list': [1, 'two', null, 3.5],
      'map': {
        'nested': {'deep': true},
      },
      'bytes': Uint8List.fromList([0, 127, 255]),
    };
    await platform.send(
      'k',
      RudderEvent.track(
        'Values',
        properties: values,
        options: RudderOption(customContext: values),
      ),
    );
    await platform.send('k', RudderEvent.identify(traits: values));

    final track = (calls[0].arguments as Map)['event'] as Map;
    expect(track['properties'], values);
    expect((track['options'] as Map)['customContext'], values);
    expect((track['properties'] as Map)['int'], isA<int>());
    expect((track['properties'] as Map)['double'], isA<double>());
    expect((track['properties'] as Map)['bytes'], isA<Uint8List>());
    expect(((calls[1].arguments as Map)['event'] as Map)['traits'], values);
  });

  test('a value that the channel cannot encode fails the call', () async {
    await expectLater(
      platform.send(
        'k',
        RudderEvent.track('Date', properties: {'at': DateTime(2026)}),
      ),
      throwsArgumentError,
    );
  });

  test(
    'getters convert nested maps from the codec to string-keyed maps',
    () async {
      replies['traits'] = <Object?, Object?>{
        'address': <Object?, Object?>{'city': 'Riyadh'},
        'tags': <Object?>[
          <Object?, Object?>{'id': 1},
        ],
      };
      replies['sessionId'] = 1234567890123;
      replies['anonymousId'] = 'anon';
      replies['userId'] = 'user';

      final traits = await platform.traits('k');

      expect(traits, {
        'address': {'city': 'Riyadh'},
        'tags': [
          {'id': 1},
        ],
      });
      expect(traits!['address'], isA<Map<String, Object?>>());
      expect((traits['tags'] as List).single, isA<Map<String, Object?>>());
      expect(await platform.sessionId('k'), 1234567890123);
      expect(await platform.anonymousId('k'), 'anon');
      expect(await platform.userId('k'), 'user');
      replies.clear();
      expect(await platform.traits('k'), isNull);
    },
  );
}
