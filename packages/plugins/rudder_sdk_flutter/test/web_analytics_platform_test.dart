@TestOn('browser')
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';
import 'package:rudder_sdk_flutter/src/platform/analytics_platform.dart';
import 'package:rudder_sdk_flutter/src/platform/web_analytics_platform.dart';

const _sdkMethods = [
  'load',
  'track',
  'page',
  'group',
  'identify',
  'alias',
  'reset',
  'startSession',
  'endSession',
  'consent',
  'getAnonymousId',
  'getUserId',
  'getUserTraits',
  'getSessionId',
];

// The loading snippet stubs these methods on an array until the SDK script loads.
const _snippetMethods = [
  'load',
  'ready',
  'page',
  'track',
  'identify',
  'alias',
  'group',
  'reset',
  'startSession',
  'endSession',
  'consent',
];

void _runJs(String script) =>
    globalContext.callMethod('eval'.toJS, script.toJS);

void _installLoadedSdk() => _runJs('''
  function _initialise() {
    document.dispatchEvent(new CustomEvent('RSA_Initialised'));
  }
  (function () {
    var sdk = { calls: [], returns: {}, defaultAnalyticsKey: '' };
    ${_jsArray(_sdkMethods)}.forEach(function (name) {
      sdk[name] = function () {
        sdk.calls.push([name].concat(Array.prototype.slice.call(arguments)));
        if (name === 'load') _initialise();
        return sdk.returns[name];
      };
    });
    window.rudderanalytics = sdk;
  })();
''');

void _installSnippet() => _runJs('''
  (function () {
    var buffer = [];
    ${_jsArray(_snippetMethods)}.forEach(function (name) {
      buffer[name] = function () {
        buffer.push([name].concat(Array.prototype.slice.call(arguments)));
      };
    });
    window.rudderanalytics = buffer;
  })();
''');

String _jsArray(List<String> names) =>
    '[${names.map((n) => "'$n'").join(',')}]';

JSObject get _sdk => globalContext['rudderanalytics']! as JSObject;

/// Each call that reached the JS SDK, as `[method, ...arguments]`, without the getters.
List<List<Object?>> _calls() {
  final calls = (_sdk['calls'] ?? _sdk) as JSArray<JSArray<JSAny?>>;
  return [
    for (final call in calls.toDart)
      if (!(call.toDart.first.dartify()! as String).startsWith('get'))
        [for (final argument in call.toDart) _dartifyArgument(argument)],
  ];
}

Object? _dartifyArgument(JSAny? argument) =>
    argument.isA<JSFunction>() ? 'function' : argument.dartify();

void _returnFromSdk(String method, JSAny? value) =>
    (_sdk['returns']! as JSObject)[method] = value;

void main() {
  final logs = <String>[];
  final originalDebugPrint = debugPrint;

  setUp(() {
    _installLoadedSdk();
    AnalyticsPlatform.instance = WebAnalyticsPlatform();
    Analytics.debugResetActiveInstances();
    logs.clear();
    debugPrint = (message, {wrapWidth}) => logs.add(message!);
  });

  tearDown(() {
    debugPrint = originalDebugPrint;
    globalContext.delete('rudderanalytics'.toJS);
  });

  Configuration config({
    String writeKey = 'key-1',
    LogLevel logLevel = LogLevel.none,
  }) => Configuration(
    writeKey: writeKey,
    dataPlaneUrl: 'https://dp.example',
    logLevel: logLevel,
  );

  group('support matrix', () {
    test(
      'load gets the shared settings and the web load options; device mode stays with the JS SDK',
      () async {
        await Analytics(
          Configuration(
            writeKey: 'key-1',
            dataPlaneUrl: 'https://dp.example',
            controlPlaneUrl: 'https://cp.example',
            logLevel: LogLevel.verbose,
            trackApplicationLifecycleEvents: false,
            flushPolicies: const [CountFlushPolicy(flushAt: 1)],
            sessionConfiguration: const SessionConfiguration(
              automaticSessionTracking: false,
              sessionTimeoutInMillis: 60000,
            ),
            consentManagement: const ConsentManagementConfiguration(
              enabled: true,
              allowedConsentIds: ['a'],
              deniedConsentIds: ['d'],
            ),
            web: const WebConfiguration(
              loadOptions: {'setCookieDomain': 'example.com'},
            ),
          ),
        ).endSession();

        expect(_calls().first, [
          'load',
          'key-1',
          'https://dp.example',
          {
            'logLevel': 'LOG',
            'configUrl': 'https://cp.example',
            'sessions': {'autoTrack': false, 'timeout': 60000},
            'consentManagement': {
              'enabled': true,
              'provider': 'custom',
              'allowedConsentIds': ['a'],
              'deniedConsentIds': ['d'],
            },
            'setCookieDomain': 'example.com',
          },
        ]);
      },
    );

    test(
      'a web load option replaces the value from the shared settings',
      () async {
        await Analytics(
          Configuration(
            writeKey: 'key-1',
            dataPlaneUrl: 'https://dp.example',
            web: const WebConfiguration(
              loadOptions: {
                'logLevel': 'ERROR',
                'sessions': {'autoTrack': false},
              },
            ),
          ),
        ).endSession();

        expect(_calls().first[3], {
          'logLevel': 'ERROR',
          'sessions': {'autoTrack': false},
        });
      },
    );

    test(
      'track, identify, group and alias reach the JS SDK with their arguments',
      () async {
        final analytics = Analytics(config());
        const options = RudderOption(
          integrations: {'Amplitude': false},
          customContext: {'campaign': 'spring'},
          externalIds: [ExternalId(type: 'crm', id: 'c-1')],
        );
        analytics.track(
          'Order Done',
          properties: {'total': 10.5},
          options: options,
        );
        analytics.identify(userId: 'u-1', traits: {'plan': 'pro'});
        analytics.identify(traits: {'age': 30}, options: options);
        analytics.group('g-1', traits: {'size': 5});
        analytics.alias('u-2', previousId: 'u-1');
        await analytics.alias('u-3', options: options);

        const jsOptions = {
          'integrations': {'Amplitude': false},
          'context': {
            'campaign': 'spring',
            'externalId': [
              {'type': 'crm', 'id': 'c-1'},
            ],
          },
        };
        expect(_calls().skip(1), [
          [
            'track',
            'Order Done',
            {'total': 10.5},
            jsOptions,
          ],
          [
            'identify',
            'u-1',
            {'plan': 'pro'},
            <String, Object?>{},
          ],
          [
            'identify',
            {'age': 30},
            jsOptions,
          ],
          [
            'group',
            'g-1',
            {'size': 5},
            <String, Object?>{},
          ],
          ['alias', 'u-2', 'u-1', <String, Object?>{}],
          ['alias', 'u-3', jsOptions],
        ]);
      },
    );

    test('screen is sent as page', () async {
      final analytics = Analytics(config());
      analytics.screen('Home', category: 'Main', properties: {'tab': 1});
      await analytics.screen('Cart');

      expect(_calls().skip(1), [
        [
          'page',
          'Main',
          'Home',
          {'tab': 1},
          <String, Object?>{},
        ],
        ['page', 'Cart', <String, Object?>{}, <String, Object?>{}],
      ]);
    });

    test(
      'reset makes a new anonymous ID unless ResetOptions keeps it',
      () async {
        final analytics = Analytics(config());
        analytics.reset();
        await analytics.reset(
          const ResetOptions(
            entries: ResetEntries(anonymousId: false, session: false),
          ),
        );

        expect(_calls().skip(1), [
          [
            'reset',
            {
              'entries': {
                'anonymousId': true,
                'userId': true,
                'userTraits': true,
                'sessionInfo': true,
              },
            },
          ],
          [
            'reset',
            {
              'entries': {
                'anonymousId': false,
                'userId': true,
                'userTraits': true,
                'sessionInfo': false,
              },
            },
          ],
        ]);
      },
    );

    test('the getters answer what the JS SDK answers', () async {
      final analytics = Analytics(config());
      _returnFromSdk('getAnonymousId', 'anon-1'.toJS);
      _returnFromSdk('getUserId', 'u-1'.toJS);
      _returnFromSdk(
        'getUserTraits',
        {
          'name': 'A',
          'age': 30,
          'score': 1.5,
          'large': 1e20,
          'address': {
            'city': 'Pune',
            'floors': [2],
          },
        }.jsify(),
      );
      _returnFromSdk('getSessionId', 1234567890123.toJS);

      expect(await analytics.anonymousId, 'anon-1');
      expect(await analytics.userId, 'u-1');
      final traits = await analytics.traits;
      expect(traits, {
        'name': 'A',
        'age': 30,
        'score': 1.5,
        'large': 1e20,
        'address': {
          'city': 'Pune',
          'floors': [2],
        },
      });
      expect(traits!['age'], isA<int>());
      expect(
        ((traits['address']! as Map)['floors'] as List).single,
        isA<int>(),
      );
      expect(await analytics.sessionId, 1234567890123);
    });

    test('the getters answer null when the JS SDK answers undefined', () async {
      final analytics = Analytics(config());

      expect(await analytics.anonymousId, isNull);
      expect(await analytics.userId, isNull);
      expect(await analytics.traits, isNull);
      expect(await analytics.sessionId, isNull);
    });

    test('startSession and endSession reach the JS SDK', () async {
      final analytics = Analytics(config());
      analytics.startSession();
      analytics.startSession(sessionId: 1234567890);
      await analytics.endSession();

      expect(_calls().skip(1), [
        ['startSession'],
        ['startSession', 1234567890],
        ['endSession'],
      ]);
    });

    test('setConsent is sent as consent', () async {
      await Analytics(config()).setConsent(
        const ConsentManagementOptions(
          allowedConsentIds: ['a'],
          deniedConsentIds: ['d'],
        ),
      );

      expect(_calls().last, [
        'consent',
        {
          'consentManagement': {
            'allowedConsentIds': ['a'],
            'deniedConsentIds': ['d'],
          },
        },
      ]);
    });

    test(
      'flush and shutdown call nothing in the JS SDK and log one line each',
      () async {
        final analytics = Analytics(config(logLevel: LogLevel.info));
        await analytics.flush();
        await analytics.shutdown();

        expect(_calls().map((call) => call.first), ['load']);
        expect(logs, [
          'Rudder-Flutter: INFO: flush() does nothing on web, because the JS SDK uploads the events by itself.',
          'Rudder-Flutter: INFO: shutdown() does not stop the JS SDK on web. The page keeps its write key.',
        ]);
      },
    );

    test(
      'a second write key throws, also after shutdown; the same write key attaches after shutdown',
      () async {
        final first = Analytics(config(logLevel: LogLevel.warn));
        expect(() => Analytics(config(writeKey: 'key-2')), throwsStateError);

        await first.shutdown();
        expect(() => Analytics(config(writeKey: 'key-2')), throwsStateError);
        final second = Analytics(config(logLevel: LogLevel.warn));
        await second.track('after');

        expect(_calls().map((call) => call.first), ['load', 'track']);
        expect(logs, [
          'Rudder-Flutter: WARN: An SDK instance for this write key already runs, so this Analytics uses it and ignores its own configuration.',
        ]);
      },
    );

    test(
      'before the SDK script loads, calls go to the snippet buffer and a getter answers after them',
      () async {
        _installSnippet();
        final analytics = Analytics(config());
        analytics.identify(userId: 'u-1');
        final userId = analytics.userId;
        await pumpEventQueue();
        expect(_calls().map((call) => call.first), ['load', 'identify']);

        _runJs('''
          window.rudderanalytics = { getUserId: function () { return 'u-1'; } };
          document.dispatchEvent(new CustomEvent('RSA_Initialised'));
        ''');
        expect(await userId, 'u-1');
      },
    );

    test(
      'a getter answers after 10 seconds when the SDK script does not load',
      () {
        _installSnippet();
        fakeAsync((async) {
          final analytics = Analytics(config(logLevel: LogLevel.warn));
          String? userId = 'not answered';
          analytics.userId.then((value) => userId = value);
          async.elapse(const Duration(seconds: 9));
          expect(userId, 'not answered');
          async.elapse(const Duration(seconds: 1));
          expect(userId, isNull);

          String? anonymousId = 'not answered';
          analytics.anonymousId.then((value) => anonymousId = value);
          async.flushMicrotasks();
          expect(anonymousId, isNull);
        });
        expect(logs, [
          'Rudder-Flutter: WARN: The JS SDK has not loaded after 10 seconds, so userId and later getters do not wait for it.',
        ]);
      },
    );

    test(
      'a write key that the page snippet loads counts as the page write key',
      () async {
        _installSnippet();
        _runJs("window.rudderanalytics.load('key-1', 'https://dp.example');");
        expect(() => Analytics(config(writeKey: 'key-2')), throwsStateError);
        await Analytics(config(logLevel: LogLevel.warn)).endSession();

        expect(_calls().map((call) => call.first), ['load', 'endSession']);
        expect(logs, [
          'Rudder-Flutter: WARN: An SDK instance for this write key already runs, so this Analytics uses it and ignores its own configuration.',
        ]);
      },
    );

    test(
      'after a hot restart, the write key of the loaded JS SDK counts as the page write key',
      () async {
        _runJs('''
          window.rudderanalytics.defaultAnalyticsKey = 'key-1';
          window.rudderanalytics.getAnalyticsInstance = function () {
            return { initialized: true };
          };
        ''');
        expect(() => Analytics(config(writeKey: 'key-2')), throwsStateError);
        final analytics = Analytics(config(logLevel: LogLevel.warn));
        await analytics.endSession();

        expect(await analytics.userId, isNull);
        expect(_calls().map((call) => call.first), ['endSession']);
        expect(logs, [
          'Rudder-Flutter: WARN: An SDK instance for this write key already runs, so this Analytics uses it and ignores its own configuration.',
        ]);
      },
    );

    test(
      'a getter waits when the snippet loaded the write key and the JS SDK still initializes',
      () async {
        _runJs('''
          window.rudderanalytics.defaultAnalyticsKey = 'key-1';
          window.rudderanalytics.getAnalyticsInstance = function () {
            return { initialized: false };
          };
        ''');
        final analytics = Analytics(config());
        analytics.identify(userId: 'u-1');
        String? userId = 'not answered';
        final answered = analytics.userId.then((value) => userId = value);
        await pumpEventQueue();
        expect(userId, 'not answered');

        _returnFromSdk('getUserId', 'u-1'.toJS);
        _runJs("document.dispatchEvent(new CustomEvent('RSA_Initialised'));");
        await answered;
        expect(userId, 'u-1');
      },
    );

    test('debug and info both map to the JS INFO level', () async {
      final jsLogLevels = <Object?>[];
      for (final level in [LogLevel.debug, LogLevel.info]) {
        _installLoadedSdk();
        AnalyticsPlatform.instance = WebAnalyticsPlatform();
        Analytics.debugResetActiveInstances();
        await Analytics(config(logLevel: level)).endSession();
        jsLogLevels.add((_calls().first[3]! as Map)['logLevel']);
      }

      expect(jsLogLevels, ['INFO', 'INFO']);
    });

    test('the engine logs at the level of the newest instance', () async {
      await Analytics(config()).shutdown();
      await Analytics(config(logLevel: LogLevel.info)).flush();

      expect(logs, [
        'Rudder-Flutter: WARN: An SDK instance for this write key already runs, so this Analytics uses it and ignores its own configuration.',
        'Rudder-Flutter: INFO: flush() does nothing on web, because the JS SDK uploads the events by itself.',
      ]);
    });
  });

  test(
    'without the JS SDK on the page, the instance shuts down and logs an error',
    () async {
      globalContext.delete('rudderanalytics'.toJS);
      final analytics = Analytics(config(logLevel: LogLevel.error));
      await analytics.track('ignored');

      expect(analytics.isShutdown, isTrue);
      expect(logs, [
        'Rudder-Flutter: ERROR: The SDK could not start: Bad state: The page has no RudderStack JS SDK. Add the loading snippet to web/index.html.',
      ]);
      expect(() => Analytics(config(writeKey: 'key-2')), returnsNormally);
    },
  );
}
