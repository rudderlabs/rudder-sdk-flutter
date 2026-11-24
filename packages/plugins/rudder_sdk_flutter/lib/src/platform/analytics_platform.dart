import '../configuration.dart';
import '../event.dart';
import '../options.dart';
import 'method_channel_analytics_platform.dart';

/// The one seam between the Dart API and the code that processes events: the native SDKs on Android and iOS, the JS SDK on web.
abstract class AnalyticsPlatform {
  /// The method channel engine; the web plugin registration sets the web engine.
  static AnalyticsPlatform instance = MethodChannelAnalyticsPlatform();

  /// Throws a [StateError] when this engine cannot run [writeKey] next to the write keys it already runs.
  void checkCanCreate(String writeKey) {}

  /// Returns `true` when an instance for the write key already runs and the Dart object [attachmentId] attached to it.
  Future<bool> create(Configuration configuration, String attachmentId);

  Future<void> send(String writeKey, RudderEvent event);

  Future<void> flush(String writeKey);

  Future<void> reset(String writeKey, ResetOptions options);

  Future<void> shutdown(String writeKey, String attachmentId);

  Future<void> startSession(String writeKey, int? sessionId);

  Future<void> endSession(String writeKey);

  Future<void> setConsent(String writeKey, ConsentManagementOptions options);

  Future<String?> anonymousId(String writeKey);

  Future<String?> userId(String writeKey);

  Future<Map<String, Object?>?> traits(String writeKey);

  Future<int?> sessionId(String writeKey);
}
