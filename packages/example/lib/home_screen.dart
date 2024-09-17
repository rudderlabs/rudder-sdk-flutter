// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rudder_plugin_db_encryption/rudder_plugin_db_encryption.dart';
import 'package:rudder_sdk_flutter/RudderController.dart';
import 'package:rudder_integration_kochava_flutter/rudder_integration_kochava_flutter.dart';
import 'package:rudder_integration_appcenter_flutter/rudder_integration_appcenter_flutter.dart';
import 'package:rudder_integration_braze_flutter/rudder_integration_braze_flutter.dart';
import 'package:rudder_integration_firebase_flutter/rudder_integration_firebase_flutter.dart';
import 'package:rudder_integration_amplitude_flutter/rudder_integration_amplitude_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

bool isInitialized = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final RudderController rudderClient = RudderController.instance;

  void __identify() {
    RudderTraits traits = RudderTraits()
        .putName("Sai Venkat")
        .putAge("22")
        .put("city", "Hyderabad")
        .put("state", "Telangana")
        .putValue({"key1": "value1", "key2": "value2"}).put("details", {
      "hobby": "football",
      "fav_color": "red"
    }).putEmail("saivenkatdesu@gmail.com");
    rudderClient.identify("161FA04009", traits: traits);
    setOutput(
        "identify : \nname:Sai Venkat\nage: 22\nemail:saivenkatdesu@gmail.com"
        "\nuserId: 161FA04009\ntraits:empty");
  }

  void __initialize() {
    RudderDBEncryption dbEncryption = RudderDBEncryption(true, "password");
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
    RudderConfigBuilder builder = RudderConfigBuilder();
    builder
      ..withFactory(RudderIntegrationKochavaFlutter())
      ..withFactory(RudderIntegrationAppcenterFlutter())
      ..withFactory(RudderIntegrationFirebaseFlutter())
      ..withFactory(RudderIntegrationBrazeFlutter())
      ..withFactory(RudderIntegrationAmplitudeFlutter())
      ..withDataPlaneUrl(
          dotenv.env['DATA_PLANE_URL'] ?? "https://hosted.rudderlabs.com")
      ..withMobileConfig(mc)
      ..withWebConfig(wc)
      ..withLogLevel(RudderLogger.VERBOSE)
      ..withDataResidencyServer(DataResidencyServer.US);
    String writeKey = dotenv.env['WRITE_KEY'] ?? "INVALID_WRITE_KEY";
    rudderClient.initialize(writeKey, config: builder.build(), options: null);
    isInitialized = true;

    setOutput("initialize:\nwriteKey: $writeKey");
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

    rudderClient.track("Went on a drive web",
        properties: property, options: options);

    setOutput(
        "track:\n\tproperty:\n\t\tcolour:red\n\t\tmanufacturer:hyundai\n\t\tmodel:i20"
        "\n\toptions:\n\t\tall:false\n\t\tMixpanel:false\n\tevent: Went on a drive");
  }

  void __screen() {
    RudderProperty screenProperty = RudderProperty();
    screenProperty
      ..put("browser", "chrome")
      ..put("device", "mac book pro");
    rudderClient.screen("Walmart Cart web",
        category: "home", properties: screenProperty, options: null);

    setOutput(
        "screen:\n\tproperty:\n\t\tbrowser: chrome\n\t\tdevice: mac book pro\n\t\tname:Walmart Cart");
  }

  void __group() {
    RudderTraits groupTraits = RudderTraits();
    groupTraits
      ..put("place", "kolkata")
      ..put("size", "fifteen")
      ..put("details", {"domain": "SDK", "type": "flutter"})
      ..putValue({"key1": "value1", "key2": "value2"});
    rudderClient.group("Integrations-Rudder", groupTraits: groupTraits);
    setOutput(
        "group\n\ttraits:\n\t\tplace:kolkata\n\t\tsize:fifteen\n\tid: Integrations-Rudder");
  }

  void __reset() {
    rudderClient.reset(clearAnonymousId: true);
    setOutput("reset");
  }

  void __alias() {
    rudderClient.alias("4009");
    setOutput("alias : 4009");
  }

  void __startSession() {
    rudderClient.startSession();
  }

  void __endSession() {
    rudderClient.endSession();
  }

  Future<void> __getSessionId() async {
    int? sessionId = await rudderClient.getSessionId();
    setOutput("Session Id : $sessionId");
  }

  Future<void> __getRudderContext() async {
    Map? context = await rudderClient.getRudderContext();
    setOutput(context.toString());
  }

//text to be displayed
  String _output = "";

  void setOutput(String text) {
    setState(() {
      _output = "output - $text";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("This is Home screen"),
                    ElevatedButton(
                      onPressed: __initialize,
                      child: const Text('Initialize SDK'),
                    ),
                    ElevatedButton(
                      onPressed: __identify,
                      child: const Text('Identify call'),
                    ),
                    ElevatedButton(
                      onPressed: __track,
                      child: const Text('Track'),
                    ),
                    ElevatedButton(
                      onPressed: __screen,
                      child: const Text('Screen'),
                    ),
                    ElevatedButton(
                      onPressed: __group,
                      child: const Text('Group'),
                    ),
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
                        child: const Text('Get Session Id')),
                    ElevatedButton(
                      onPressed: __reset,
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: __alias,
                      child: const Text('Alias'),
                    ),
                    ElevatedButton(
                      child: const Text('Rudder Context'),
                      onPressed: () async => await __getRudderContext(),
                    ),
                    ElevatedButton(
                      onPressed: __getRudderContext,
                      child: const Text('Set Advertsing ID'),
                    ),
                    ElevatedButton(
                      child: const Text('Go to screen 2'),
                      onPressed: () =>
                          Navigator.of(context).pushNamed('screen2'),
                    ),
                    Text(_output)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
