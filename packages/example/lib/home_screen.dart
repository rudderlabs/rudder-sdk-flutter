// ignore_for_file: unused_element

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final RudderController rudderClient = RudderController.instance;

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

    setOutput("identify: \n${identifyArgs.toString()}");
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

    setOutput("initialize:\n${initArgs.toString()}");
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

    setOutput("track:\n${trackArgs.toString()}");
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

    setOutput("screen:\n${screenArgs.toString()}");
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

    setOutput("group:\n${groupArgs.toString()}");
  }

  void __reset() {
    rudderClient.reset(clearAnonymousId: true);
    setOutput("reset");
  }

  void __alias() {
    Map<String, dynamic> aliasArgs = {"User ID": "4009"};

    rudderClient.alias(aliasArgs["User ID"] as String);

    setOutput("alias:\n${aliasArgs.toString()}");
  }

  void __startSession() {
    rudderClient.startSession();
  }

  void __endSession() {
    rudderClient.endSession();
  }

  Future<void> __getSessionId() async {
    int? sessionId = await rudderClient.getSessionId();

    setOutput("getSessionId:\n$sessionId");
  }

  Future<void> __getRudderContext() async {
    Map? context = await rudderClient.getRudderContext();

    setOutput("getRudderContext:\n${context.toString()}");
  }

//text to be displayed
  String _output = "";

  void setOutput(String text) {
    setState(() {
      _output = text;
    });
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
                color: Colors.black87,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Text(
                  _output,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
