@JS('rudderanalytics')
library rudder_analytics.js;

import 'dart:js_interop';

@JS("load")
external void load(JSString writeKey, JSString dataPlaneUrl, JSObject? options);

@JS('setAnonymousId')
external void setAnonymousId(JSString anonymousId);

@JS('identify')
external void identify(JSString userId, JSObject? traits, JSObject? options);

@JS('page')
external void page(JSString? category, JSString name, JSObject? properties, JSObject? options);

@JS('track')
external void track(JSString event, JSObject? properties, JSObject? options);

@JS('alias')
external void alias(JSString to, JSObject? options);

@JS('group')
external void group(JSString groupId, JSObject? traits, JSObject? options);

@JS('reset')
external void reset(JSBoolean clearAnonymousId);

@JS('startSession')
external void startSession(JSNumber? sessionId);

@JS('endSession')
external void endSession();

@JS('getAnonymousId')
external JSString? getAnonymousId();

@JS('getUserTraits')
external JSObject? getUserTraits();

@JS('getSessionId')
external JSNumber? getSessionId();