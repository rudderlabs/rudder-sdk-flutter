@JS()
library rudder_analytics.js;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

void load(String writeKey, String dataPlaneUrl, Object? options) {
  _load(writeKey.toJS, dataPlaneUrl.toJS, myJsify(options));
}

void setAnonymousId(String anonymousId) {
  _setAnonymousId(anonymousId.toJS);
}

void identify(String userId, Object? traits, Object? options) {
  _identify(userId.toJS, myJsify(traits), myJsify(options));
}

void page(String? category, String name, Object? properties, Object? options) {
  _page(category?.toJS, name.toJS, myJsify(properties), myJsify(options));
}

void track(String event, Object? properties, Object? options) {
  _track(event.toJS, myJsify(properties), myJsify(options));
}

void alias(String to, Object? options) {
  _alias(to.toJS, myJsify(options));
}

void group(String groupId, Object? traits, Object? options) {
  _group(groupId.toJS, myJsify(traits), myJsify(options));
}

void reset(bool clearAnonymousId) {
  _reset(clearAnonymousId.toJS);
}

void startSession(int? sessionId) {
  _startSession(sessionId?.toJS);
}

void endSession() {
  _endSession();
}

String? getAnonymousId() {
  final result = _getAnonymousId();
  return result?.toDart;
}

dynamic getUserTraits() {
  // TODO: Implement this for web
  throw UnimplementedError('getUserTraits is not available for web yet');
}

int? getSessionId() {
  final result = _getSessionId();
  return result?.toDartInt;
}

@JS("rudderanalytics.load")
external void _load(JSString writeKey, JSString dataPlaneUrl, JSAny? options);

@JS('rudderanalytics.setAnonymousId')
external void _setAnonymousId(JSString anonymousId);

@JS('rudderanalytics.identify')
external void _identify(JSString userId, JSAny? traits, JSAny? options);

@JS('rudderanalytics.page')
external void _page(
    JSAny? category, JSString name, JSAny? properties, JSAny? options);

@JS('rudderanalytics.track')
external void _track(JSString event, JSAny? properties, JSAny? options);

@JS('rudderanalytics.alias')
external void _alias(JSString to, JSAny? options);

@JS('rudderanalytics.group')
external void _group(JSString groupId, JSAny? traits, JSAny? options);

@JS('rudderanalytics.reset')
external void _reset(JSBoolean clearAnonymousId);

@JS('rudderanalytics.startSession')
external void _startSession(JSAny? sessionId);

@JS('rudderanalytics.endSession')
external void _endSession();

@JS('rudderanalytics.getAnonymousId')
external JSString? _getAnonymousId();

@JS('rudderanalytics.getUserTraits')
external JSAny? _getUserTraits();

@JS('rudderanalytics.getSessionId')
external JSNumber? _getSessionId();

JSObject newJSObject() => JSObject();

JSArray newJSArray() => JSArray();

extension JSArrayExt on JSArray {
  external void push(JSAny? value);
}

JSAny? myJsify(Object? object) {
  if (object == null) return null;
  if (object is Map) {
    return mapToJSObj(object);
  } else if (object is Iterable) {
    final jsArr = newJSArray();
    for (final element in object) {
      jsArr.push(myJsify(element));
    }
    return jsArr;
  } else if (object is String) {
    return object.toJS;
  } else if (object is num) {
    return object.toJS;
  } else if (object is bool) {
    return object.toJS;
  }
  throw ArgumentError('Unsupported type: ${object.runtimeType}');
}

JSObject mapToJSObj(Map<dynamic, dynamic> map) {
  final jsObj = newJSObject();
  map.forEach((k, v) {
    if (k is! String) {
      throw ArgumentError('Map keys must be strings. Found: ${k.runtimeType}');
    }
    final jsKey = k.toJS;
    final jsValue = myJsify(v);
    jsObj.setProperty(jsKey, jsValue);
  });
  return jsObj;
}
