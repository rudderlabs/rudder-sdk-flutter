// ignore_for_file: unused_element, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rudder_plugin_db_encryption/rudder_plugin_db_encryption.dart';
import 'package:rudder_sdk_flutter/RudderController.dart';
import 'package:rudder_integration_appcenter_flutter/rudder_integration_appcenter_flutter.dart';
import 'package:rudder_integration_braze_flutter/rudder_integration_braze_flutter.dart';
import 'package:rudder_integration_firebase_flutter/rudder_integration_firebase_flutter.dart';
import 'package:rudder_integration_amplitude_flutter/rudder_integration_amplitude_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

bool isInitialized = false;
const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final RudderController rudderClient = RudderController.instance;

  @override
  void initState() {
    super.initState();
    // Print WASM boolean value to output on startup
    setOutput("Is Running with Wasm: $isRunningWithWasm");
  }

  void __identify() {
    RudderTraits traits = RudderTraits()
        .putName("John Doe")
        .putAge("22")
        .put("city", "New York")
        .put("state", "New York")
        .putValue({"key1": "value1", "key2": "value2"}).put("details", {
      "hobby": "football",
      "fav_color": "red"
    }).putEmail("john.doe@example.com");

    Map<String, dynamic> identifyArgs = {
      "User ID": "1234567890",
      "Traits": traits
    };

    rudderClient.identify(identifyArgs["User ID"] as String,
        traits: identifyArgs["Traits"] as RudderTraits);

    setOutput("identify: \n${formatJson(identifyArgs)}");
  }

  void __initialize() {
    RudderDBEncryption? dbEncryption;
    if (!kIsWeb) {
      dbEncryption = RudderDBEncryption(true, "password");
    }
    MobileConfig mc = MobileConfig(
        autoCollectAdvertId: false,
        sessionTimeoutInMillis: 6000,
        dbEncryption: dbEncryption,
        gzip: false,
        recordScreenViews: true,
        collectDeviceId: false);
    WebConfig wc = WebConfig(
      storage: StorageOpts(type: StorageType.localStorage, entries: {
        UserSessionKey.anonymousId:
            StorageEntry(type: StorageType.cookieStorage)
      }),
      lockIntegrationsVersion: true,
      lockPluginsVersion: true,
    );

    Map<String, dynamic> initArgs = {
      "Write Key": dotenv.env['WRITE_KEY'] as String,
      "Data Plane URL": dotenv.env['DATA_PLANE_URL'] as String,
      "Web Config": wc,
      "Mobile Config": mc,
      "Log Level": RudderLogger.VERBOSE,
      "Data Residency Server": DataResidencyServer.US,
    };

    RudderConfigBuilder builder = RudderConfigBuilder();
    builder
      ..withFactory(RudderIntegrationAppcenterFlutter())
      ..withFactory(RudderIntegrationFirebaseFlutter())
      ..withFactory(RudderIntegrationBrazeFlutter())
      ..withFactory(RudderIntegrationAmplitudeFlutter())
      ..withDataPlaneUrl(initArgs["Data Plane URL"] as String)
      ..withMobileConfig(mc)
      ..withWebConfig(wc)
      ..withLogLevel(initArgs["Log Level"] as int)
      ..withDataResidencyServer(
          initArgs["Data Residency Server"] as DataResidencyServer);
    rudderClient.initialize(initArgs["Write Key"] as String,
        config: builder.build(), options: null);
    isInitialized = true;

    setOutput("initialize:\n${formatJson(initArgs)}");
  }

  void __track() {
    RudderProperty property = RudderProperty();
    property
      ..put("colour", "red")
      ..put("manufacturer", "hyundai")
      ..put("model", "i20")
      ..put("marks", [1, 2, 3, 4])
      ..put("something nested", [
        {
          "nest_2": [76, 78],
          "nest_2_1": {"nest_2_2": "some val"}
        },
        {
          "string_arr": ["a", "b"]
        }
      ]);

    RudderOption options = RudderOption();
    options
      ..putIntegration("All", true)
      ..putIntegration("Mixpanel", false)
      ..putCustomContext("address", {
        "city": "kolkata",
        "pin": "700091",
        "state": {"name": "West Bengal", "code": "WB"},
        "country": {"name": "India", "code": "IN"},
        "zone": 12,
        "lat": 22.5726,
      });

    Map<String, dynamic> trackArgs = {
      "Event": "Went on a drive web",
      "Properties": property,
      "Options": options
    };

    rudderClient.track(trackArgs["Event"] as String,
        properties: trackArgs["Properties"] as RudderProperty,
        options: trackArgs["Options"] as RudderOption);

    setOutput("track:\n${formatJson(trackArgs)}");
  }

  void __screen() {
    RudderProperty screenProperty = RudderProperty();
    screenProperty
      ..put("browser", "chrome")
      ..put("device", "mac book pro");

    Map<String, dynamic> screenArgs = {
      "Name": "Walmart Cart web",
      "Category": "home",
      "Properties": screenProperty,
      "Options": null
    };

    rudderClient.screen(screenArgs["Name"] as String,
        category: screenArgs["Category"] as String,
        properties: screenArgs["Properties"] as RudderProperty,
        options: screenArgs["Options"]);

    setOutput("screen:\n${formatJson(screenArgs)}");
  }

  void __group() {
    RudderTraits groupTraits = RudderTraits();
    groupTraits
      ..put("place", "kolkata")
      ..put("size", "fifteen")
      ..put("details", {"domain": "SDK", "type": "flutter"})
      ..putValue({"key1": "value1", "key2": "value2"});

    Map<String, dynamic> groupArgs = {
      "Group ID": "Integrations-Rudder",
      "Traits": groupTraits
    };

    rudderClient.group(groupArgs["Group ID"] as String,
        groupTraits: groupArgs["Traits"] as RudderTraits);

    setOutput("group:\n${formatJson(groupArgs)}");
  }

  void __reset() {
    Map<String, dynamic> resetArgs = {"Clear Anonymous ID": true};
    rudderClient.reset(
        clearAnonymousId: resetArgs["Clear Anonymous ID"] as bool);

    setOutput("reset:\n${formatJson(resetArgs)}");
  }

  void __alias() {
    Map<String, dynamic> aliasArgs = {"User ID": "4009"};

    rudderClient.alias(aliasArgs["User ID"] as String);

    setOutput("alias:\n${formatJson(aliasArgs)}");
  }

  void __startSession() {
    Map<String, dynamic> startSessionArgs = {"Session ID": 1234567890};
    rudderClient.startSession(sessionId: startSessionArgs["Session ID"]);

    setOutput("startSession:\n${formatJson(startSessionArgs)}");
  }

  void __endSession() {
    rudderClient.endSession();

    setOutput("endSession");
  }

  Future<void> __getSessionId() async {
    int? sessionId = await rudderClient.getSessionId();

    setOutput("getSessionId:\n$sessionId");
  }

  Future<void> __getRudderContext() async {
    Map? context = await rudderClient.getRudderContext();

    setOutput("getRudderContext:\n${formatJson(context)}");
  }

  void __optOut() {
    Map<String, dynamic> optOutArgs = {"Opt Out": true};
    rudderClient.optOut(optOutArgs["Opt Out"] as bool);

    setOutput("optOut:\n${formatJson(optOutArgs)}");
  }

  void __optIn() {
    Map<String, dynamic> optInArgs = {"Opt In": false};
    rudderClient.optOut(optInArgs["Opt In"] as bool);

    setOutput("optIn:\n${formatJson(optInArgs)}");
  }

  void __putAnonymousId() {
    Map<String, dynamic> putAnonymousIdArgs = {
      "Anonymous ID": "anonymous_${DateTime.now().millisecondsSinceEpoch}"
    };

    String anonymousId = putAnonymousIdArgs["Anonymous ID"] as String;
    rudderClient.putAnonymousId(anonymousId);
    setOutput("putAnonymousId:\n${formatJson(putAnonymousIdArgs)}");
  }

  void __putDeviceToken() {
    Map<String, dynamic> putDeviceTokenArgs = {
      "Device Token": "device_token_${DateTime.now().millisecondsSinceEpoch}"
    };

    String deviceToken = putDeviceTokenArgs["Device Token"] as String;
    rudderClient.putDeviceToken(deviceToken);
    setOutput("putDeviceToken:\n${formatJson(putDeviceTokenArgs)}");
  }

  void __putAdvertisingId() {
    Map<String, dynamic> putAdvertisingIdArgs = {
      "Advertising ID":
          "advertising_id_${DateTime.now().millisecondsSinceEpoch}"
    };

    String advertisingId = putAdvertisingIdArgs["Advertising ID"] as String;
    rudderClient.putAdvertisingId(advertisingId);
    setOutput("putAdvertisingId:\n${formatJson(putAdvertisingIdArgs)}");
  }

  //text to be displayed
  String _output = "";

  dynamic makeJsonSerializable(dynamic obj) {
    if (obj == null) return null;

    if (obj is String || obj is num || obj is bool) {
      return obj;
    }

    if (obj is List) {
      return obj.map((item) => makeJsonSerializable(item)).toList();
    }

    if (obj is Map) {
      final result = <String, dynamic>{};
      obj.forEach((key, value) {
        result[key.toString()] = makeJsonSerializable(value);
      });
      return result;
    }

    // Handle special Rudder classes by extracting their underlying Map data
    if (obj is RudderTraits) {
      return makeJsonSerializable(obj.toWebTraits());
    }

    if (obj is RudderProperty) {
      return makeJsonSerializable(obj.getMap());
    }

    if (obj is RudderOption) {
      return makeJsonSerializable(obj.toWebMap());
    }

    // For other custom objects, convert to string representation
    return obj.toString();
  }

  String formatJson(dynamic data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');

      // Convert to JSON-serializable format first
      final serializable = makeJsonSerializable(data);
      return encoder.convert(serializable);
    } catch (e) {
      return "Error formatting: ${data.toString()}\nException: $e";
    }
  }

  void setOutput(String text) {
    setState(() {
      _output = text;
    });

    if (kIsWeb) {
      print(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  children: [
                    const Text(
                      "RudderStack Flutter Web SDK Example - Home Screen",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Initialization",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: __initialize,
                                    child: const Text('Initialize SDK'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("User Actions",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: __identify,
                                  child: const Text('Identify User'),
                                ),
                                ElevatedButton(
                                  onPressed: __track,
                                  child: const Text('Track Event'),
                                ),
                                ElevatedButton(
                                  onPressed: __screen,
                                  child: const Text('Screen Event'),
                                ),
                                ElevatedButton(
                                  onPressed: __group,
                                  child: const Text('Group'),
                                ),
                                ElevatedButton(
                                  onPressed: __alias,
                                  child: const Text('Alias User'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Session Management",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: __startSession,
                                  child: const Text('Start Session'),
                                ),
                                ElevatedButton(
                                  onPressed: __endSession,
                                  child: const Text('End Session'),
                                ),
                                ElevatedButton(
                                  onPressed: __getSessionId,
                                  child: const Text('Get Session Id'),
                                ),
                                ElevatedButton(
                                  onPressed: __reset,
                                  child: const Text('Reset'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Data Management",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: __optOut,
                                  child: const Text('Opt Out'),
                                ),
                                ElevatedButton(
                                  onPressed: __optIn,
                                  child: const Text('Opt In'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("User Identification",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: __putAnonymousId,
                                  child: const Text('Put Anonymous ID'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Device Information",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: __putDeviceToken,
                                  child: const Text('Put Device Token'),
                                ),
                                ElevatedButton(
                                  onPressed: __putAdvertisingId,
                                  child: const Text('Put Advertising ID'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Utilities",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: () async =>
                                      await __getRudderContext(),
                                  child: const Text('Get Rudder Context'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Navigation",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed('screen2'),
                                  child: const Text('Go to screen 2'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.black87,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: SingleChildScrollView(
                  child: Text(
                    _output,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
