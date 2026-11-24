import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';
import 'package:rudder_sdk_flutter_example/second_engine.dart';

import 'support/mock_data_plane.dart';
import 'support/test_host.dart';

const attachWarning =
    'Rudder-Flutter: WARN: An SDK instance for this write key already runs, so this Analytics uses it and ignores its own configuration.';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MockDataPlane server;
  final logs = <String>[];
  final originalDebugPrint = debugPrint;

  setUpAll(() async => server = await MockDataPlane.start());
  tearDownAll(() => server.stop());
  setUp(() {
    logs.clear();
    debugPrint = (message, {wrapWidth}) {
      logs.add(message ?? '');
      originalDebugPrint(message, wrapWidth: wrapWidth);
    };
  });
  tearDown(() => debugPrint = originalDebugPrint);

  Analytics analyticsFor(
    String writeKey, {
    bool trackApplicationLifecycleEvents = false,
  }) => Analytics(
    testConfiguration(
      writeKey,
      server.url,
      trackApplicationLifecycleEvents: trackApplicationLifecycleEvents,
    ),
  );

  /// Creates an `Analytics` for [writeKey] in a new engine, and reports whether it attached to a running native instance.
  Future<bool> attachesToRunningInstance(String writeKey) async {
    final probe = await TestEngine.start();
    await probe.create(writeKey, server.url);
    final attached = (await probe.logs()).contains(attachWarning);
    await probe.shutdown();
    await probe.destroy();
    return attached;
  }

  testWidgets(
    'a second engine shares the instance, and the last Dart shutdown stops it',
    (tester) async {
      final writeKey = uniqueWriteKey('two-engines');
      final main = analyticsFor(writeKey);
      await main.track('Main 1');
      final engine = await TestEngine.start();
      await engine.create(writeKey, server.url);
      expect(await engine.logs(), contains(attachWarning));
      await engine.track('Engine 1');

      await engine.shutdown();
      await main.track('Main After Engine Shutdown');
      final events = await server.waitForEvents(
        writeKey,
        (_) => true,
        count: 3,
      );
      expect(events.map(describe), [
        'track:Main 1',
        'track:Engine 1',
        'track:Main After Engine Shutdown',
      ]);
      expect(events.map((event) => event['anonymousId']).toSet(), hasLength(1));

      await main.shutdown();
      expect(await attachesToRunningInstance(writeKey), isFalse);
      await engine.destroy();
    },
  );

  testWidgets(
    'an instance that native code started never stops from Dart, in any engine',
    (tester) async {
      final writeKey = uniqueWriteKey('native');
      await startNativeInstance(writeKey, server.url);
      final dart = analyticsFor(writeKey);
      await dart.track('Dart 1');
      expect(logs, contains(attachWarning));
      final engine = await TestEngine.start();
      await engine.create(writeKey, server.url);
      await engine.track('Engine 1');

      await dart.shutdown();
      await nativeTrack(writeKey, 'Native After Dart Shutdown');
      await engine.track('Engine After Dart Shutdown');
      await engine.shutdown();
      await nativeTrack(writeKey, 'Native After Every Dart Shutdown');
      await engine.destroy();
      await nativeTrack(writeKey, 'Native After Engine Ended');

      final events = await server.waitForEvents(
        writeKey,
        (_) => true,
        count: 6,
      );
      expect(events.map(describe), [
        'track:Dart 1',
        'track:Engine 1',
        'track:Native After Dart Shutdown',
        'track:Engine After Dart Shutdown',
        'track:Native After Every Dart Shutdown',
        'track:Native After Engine Ended',
      ]);
      expect(events.map((event) => event['anonymousId']).toSet(), hasLength(1));
      expect(await attachesToRunningInstance(writeKey), isTrue);
    },
  );

  testWidgets(
    'after native code stops its instance, the next Dart Analytics starts its own',
    (tester) async {
      final writeKey = uniqueWriteKey('native-stops');
      await startNativeInstance(writeKey, server.url);
      final attached = analyticsFor(writeKey);
      await attached.track('Dart 1');
      await server.waitForTrack(writeKey, 'Dart 1');
      await stopNativeInstance(writeKey);
      await attached.shutdown();
      logs.clear();

      final dart = analyticsFor(writeKey);
      await dart.track('Dart After Native Stopped');

      final events = await server.waitForEvents(
        writeKey,
        (_) => true,
        count: 2,
      );
      expect(events.map(describe), [
        'track:Dart 1',
        'track:Dart After Native Stopped',
      ]);
      expect(logs, isNot(contains(attachWarning)));
      await dart.shutdown();
      expect(await attachesToRunningInstance(writeKey), isFalse);
    },
  );

  testWidgets(
    'after native code replaces its instance, an attached Dart Analytics sends through the new one',
    (tester) async {
      final writeKey = uniqueWriteKey('native-replaced');
      await startNativeInstance(writeKey, server.url);
      final dart = analyticsFor(writeKey);
      await dart.track('Dart 1');
      await server.waitForTrack(writeKey, 'Dart 1');

      await stopNativeInstance(writeKey);
      await startNativeInstance(writeKey, server.url);
      await dart.track('Dart After Replacement');

      await server.waitForTrack(writeKey, 'Dart After Replacement');
      await dart.shutdown();
      await nativeTrack(writeKey, 'Native After Dart Shutdown');
      await server.waitForTrack(writeKey, 'Native After Dart Shutdown');
    },
  );

  testWidgets(
    'native code that starts an instance after Dart is refused, and Dart keeps sending',
    (tester) async {
      final writeKey = uniqueWriteKey('native-late');
      final dart = analyticsFor(writeKey);
      await dart.track('Dart 1');
      await server.waitForTrack(writeKey, 'Dart 1');

      await startNativeInstance(writeKey, server.url);
      await nativeTrack(writeKey, 'Native Refused');
      await dart.track('Dart 2');

      final events = await server.waitForEvents(
        writeKey,
        (_) => true,
        count: 2,
      );
      expect(events.map(describe), ['track:Dart 1', 'track:Dart 2']);
      await dart.shutdown();
    },
  );

  testWidgets(
    'an engine that ends without a shutdown leaves the instance running for the other engines',
    (tester) async {
      final writeKey = uniqueWriteKey('engine-ends');
      final main = analyticsFor(writeKey);
      final engine = await TestEngine.start();
      await engine.create(writeKey, server.url);
      await engine.track('Engine 1');
      await engine.destroy();

      await main.track('Main After Engine Ended');
      await server.waitForTrack(writeKey, 'Main After Engine Ended');
      await main.shutdown();
      expect(await attachesToRunningInstance(writeKey), isFalse);
    },
  );

  testWidgets(
    'when the last engine ends without a shutdown, a new engine attaches to the running instance',
    (tester) async {
      final writeKey = uniqueWriteKey('last-engine-ends');
      final first = await TestEngine.start();
      await first.create(writeKey, server.url);
      await first.track('First Engine');
      await first.destroy();

      final second = await TestEngine.start();
      await second.create(writeKey, server.url);
      expect(await second.logs(), contains(attachWarning));
      await second.track('Second Engine');
      final events = await server.waitForEvents(
        writeKey,
        (_) => true,
        count: 2,
      );
      expect(events.map((event) => event['anonymousId']).toSet(), hasLength(1));

      await second.shutdown();
      expect(await attachesToRunningInstance(writeKey), isFalse);
      await second.destroy();
    },
  );

  testWidgets(
    'an engine that ends after its shutdown does not take the attachment of another engine',
    (tester) async {
      final writeKey = uniqueWriteKey('shutdown-then-end');
      final main = analyticsFor(writeKey);
      final engine = await TestEngine.start();
      await engine.create(writeKey, server.url);
      await engine.shutdown();
      await engine.destroy();

      await main.track('Main After Engine Shutdown And End');
      await server.waitForTrack(writeKey, 'Main After Engine Shutdown And End');
      expect(await attachesToRunningInstance(writeKey), isTrue);
      await main.shutdown();
      expect(await attachesToRunningInstance(writeKey), isFalse);
    },
  );

  testWidgets('five engine attaches send no duplicate lifecycle events', (
    tester,
  ) async {
    final writeKey = uniqueWriteKey('five-engines');
    final main = analyticsFor(writeKey, trackApplicationLifecycleEvents: true);
    await main.track('Before Engines');
    await server.waitForTrack(writeKey, 'Before Engines');
    final lifecycleBefore = lifecycleEvents(
      await server.eventsAfter(writeKey, const Duration(seconds: 2)),
    );
    expect(lifecycleBefore, isNotEmpty);

    for (var round = 1; round <= 5; round++) {
      final engine = await TestEngine.start();
      await engine.create(writeKey, server.url);
      expect(await engine.logs(), contains(attachWarning));
      await engine.track('Engine $round');
      await engine.destroy();
    }
    await main.track('After Engines');
    await server.waitForTrack(writeKey, 'After Engines');

    final events = await server.eventsAfter(
      writeKey,
      const Duration(seconds: 3),
    );
    expect(lifecycleEvents(events), lifecycleBefore);
    expect(
      events.where(
        (event) => (event['event'] as String?)?.startsWith('Engine ') ?? false,
      ),
      hasLength(5),
    );
    expect(events.map((event) => event['anonymousId']).toSet(), hasLength(1));
    await main.shutdown();
  });

  testWidgets(
    'four Activity re-creations send no duplicate lifecycle events',
    (tester) async {
      final writeKey = uniqueWriteKey('activity');
      final main = analyticsFor(
        writeKey,
        trackApplicationLifecycleEvents: true,
      );
      await main.track('Before Activity');
      await server.waitForTrack(writeKey, 'Before Activity');
      final lifecycleBefore = lifecycleEvents(
        await server.eventsAfter(writeKey, const Duration(seconds: 2)),
      );
      expect(lifecycleBefore, isNotEmpty);

      final activity = await TestEngine.startActivity();
      for (var round = 0; round <= 4; round++) {
        if (round > 0) await activity.recreateActivity();
        await activity.create(writeKey, server.url);
        await activity.track('Activity $round');
      }
      await activity.destroy();
      await main.track('After Activity');
      await server.waitForTrack(writeKey, 'After Activity');

      final events = await server.eventsAfter(
        writeKey,
        const Duration(seconds: 3),
      );
      expect(lifecycleEvents(events), lifecycleBefore);
      expect(
        events.where(
          (event) =>
              (event['event'] as String?)?.startsWith('Activity ') ?? false,
        ),
        hasLength(5),
      );
      expect(events.map((event) => event['anonymousId']).toSet(), hasLength(1));
      await main.shutdown();
    },
    skip: !Platform.isAndroid,
  );

  testWidgets(
    'when native code runs a Kotlin core instance for the write key, the Dart start fails and the core instance keeps working',
    (tester) async {
      final writeKey = uniqueWriteKey('core-instance');
      await startNativeCoreInstance(writeKey, server.url);
      final dart = analyticsFor(writeKey);
      await dart.track('Dart');

      expect(dart.isShutdown, isTrue);
      expect(
        logs,
        contains(startsWith('Rudder-Flutter: ERROR: The SDK could not start:')),
      );
      await nativeTrack(writeKey, 'Native');
      await server.waitForTrack(writeKey, 'Native');
      expect(server.events(writeKey).map(describe), ['track:Native']);
      await stopNativeInstance(writeKey);
    },
    skip: !Platform.isAndroid,
  );
}

/// The names of the application lifecycle events, in order.
List<String> lifecycleEvents(List<Map<String, dynamic>> events) => [
  for (final event in events)
    if (event['type'] == 'track' &&
        (event['event'] as String).startsWith('Application '))
      event['event'] as String,
];
