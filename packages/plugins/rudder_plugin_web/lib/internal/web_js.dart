@JS('rudderanalytics')
library;

import 'dart:js_interop';

void load(String writeKey, String dataPlaneUrl, Map<String, dynamic>? options) {
  _load(writeKey.toJS, dataPlaneUrl.toJS, mapToJSObj(options));
}

void setAnonymousId(String anonymousId) {
  _setAnonymousId(anonymousId.toJS);
}

void identify(String userId, Map<String, dynamic>? traits,
    Map<String, dynamic>? options) {
  _identify(userId.toJS, mapToJSObj(traits), mapToJSObj(options));
}

void page(String? category, String name, Map<String, dynamic>? properties,
    Map<String, dynamic>? options) {
  _page(category?.toJS, name.toJS, mapToJSObj(properties), mapToJSObj(options));
}

void track(String event, Map<String, dynamic>? properties,
    Map<String, dynamic>? options) {
  _track(event.toJS, mapToJSObj(properties), mapToJSObj(options));
}

void alias(String to, Map<String, dynamic>? options) {
  _alias(to.toJS, mapToJSObj(options));
}

void group(String groupId, Map<String, dynamic>? traits,
    Map<String, dynamic>? options) {
  _group(groupId.toJS, mapToJSObj(traits), mapToJSObj(options));
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
  final result = _getUserTraits();
  return result?.dartify();
}

int? getSessionId() {
  final result = _getSessionId();
  return result?.toDartInt;
}

@JS("load")
external void _load(
    JSString writeKey, JSString dataPlaneUrl, JSObject? options);

@JS('setAnonymousId')
external void _setAnonymousId(JSString anonymousId);

@JS('identify')
external void _identify(JSString userId, JSObject? traits, JSObject? options);

@JS('page')
external void _page(
    JSString? category, JSString name, JSObject? properties, JSObject? options);

@JS('track')
external void _track(JSString event, JSObject? properties, JSObject? options);

@JS('alias')
external void _alias(JSString to, JSObject? options);

@JS('group')
external void _group(JSString groupId, JSObject? traits, JSObject? options);

@JS('reset')
external void _reset(JSBoolean clearAnonymousId);

@JS('startSession')
external void _startSession(JSNumber? sessionId);

@JS('endSession')
external void _endSession();

@JS('getAnonymousId')
external JSString? _getAnonymousId();

@JS('getUserTraits')
external JSObject? _getUserTraits();

@JS('getSessionId')
external JSNumber? _getSessionId();

extension JSArrayExt on JSArray {
  external void push(JSAny? value);
}

extension JSObjectExt on JSObject {
  external void operator []=(JSString key, JSAny? value);
}

JSAny? convertToJS(Object? object) {
  if (object == null) return null;
  if (object is Map<String, dynamic>) {
    return mapToJSObj(object);
  } else if (object is Iterable) {
    final jsArr = JSArray();
    for (final element in object) {
      jsArr.push(convertToJS(element));
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

JSObject? mapToJSObj(Map<String, dynamic>? map) {
  if (map == null) return null;
  final jsObj = JSObject();
  map.forEach((k, v) {
    final jsKey = k.toJS;
    final jsValue = convertToJS(v);
    jsObj[jsKey] = jsValue;
  });
  return jsObj;
}
