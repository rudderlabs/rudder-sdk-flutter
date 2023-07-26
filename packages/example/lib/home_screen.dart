import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rudder_sdk_flutter/RudderController.dart';
import 'package:rudder_integration_appcenter_flutter/rudder_integration_appcenter_flutter.dart';
import 'package:rudder_integration_amplitude_flutter/rudder_integration_amplitude_flutter.dart';
import 'package:rudder_integration_braze_flutter/rudder_integration_braze_flutter.dart';
import 'package:rudder_integration_firebase_flutter/rudder_integration_firebase_flutter.dart';
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
        .putEmail("saivenkatdesu@gmail.com");
    rudderClient.identify("161FA04009", traits: traits);
    setOutput(
        "identify : \nname:Sai Venkat\nage: 22\nemail:saivenkatdesu@gmail.com"
        "\nuserId: 161FA04009\ntraits:empty");
  }

  void __initialize() {
    MobileConfig mc = MobileConfig(autoCollectAdvertId: false);
    RudderConfigBuilder builder = RudderConfigBuilder();
    builder.withFactory(RudderIntegrationAppcenterFlutter());
    builder.withFactory(RudderIntegrationFirebaseFlutter());
    builder.withFactory(RudderIntegrationBrazeFlutter());
    builder.withFactory(RudderIntegrationAmplitudeFlutter());
    builder.withDataPlaneUrl(
        dotenv.env['DATA_PLANE_URL'] ?? "https://hosted.rudderlabs.com");
    builder.withMobileConfig(mc);
    builder.withLogLevel(RudderLogger.VERBOSE);
    builder.withDataResidency("US");
    String writeKey = dotenv.env['WRITE_KEY'] ?? "INVALID_WRITE_KEY";
    rudderClient.initialize(writeKey, config: builder.build(), options: null);
    isInitialized = true;

    setOutput("initialize:\nwriteKey: $writeKey");
  }

  void __track() {
    RudderProperty property = RudderProperty();
    property.put("colour", "red");
    property.put("manufacturer", "hyundai");
    property.put("model", "i20");
    property.put("marks", [1, 2, 3, 4]);
    property.put("something nested", [
      {
        "nest_2": [76, 78],
        "nest_2_1": {"nest_2_2": "some val"}
      },
      {
        "string_arr": ["a", "b"]
      }
    ]);
    RudderOption options = RudderOption();
    options.putIntegration("All", true);
    options.putIntegration("Mixpanel", false);
    rudderClient.track("Went on a drive web",
        properties: property, options: options);

    setOutput(
        "track:\n\tproperty:\n\t\tcolour:red\n\t\tmanufacturer:hyundai\n\t\tmodel:i20"
        "\n\toptions:\n\t\tall:false\n\t\tMixpanel:false\n\tevent: Went on a drive");
  }

  void __screen() {
    RudderProperty screenProperty = RudderProperty();
    screenProperty.put("browser", "chrome");
    screenProperty.put("device", "mac book pro");
    rudderClient.screen("Walmart Cart web",
        category: "home", properties: screenProperty, options: null);

    setOutput(
        "screen:\n\tproperty:\n\t\tbrowser: chrome\n\t\tdevice: mac book pro\n\t\tname:Walmart Cart");
  }

  void __group() {
    RudderTraits groupTraits = RudderTraits();
    groupTraits.put("place", "kolkata");
    groupTraits.put("size", "fifteen");
    rudderClient.group("Integrations-Rudder", groupTraits: groupTraits);
    setOutput(
        "group\n\ttraits:\n\t\tplace:kolkata\n\t\tsize:fifteen\n\tid: Integrations-Rudder");
  }

  void __reset() {
    rudderClient.reset();
    setOutput("reset");
  }

  void __alias() {
    rudderClient.alias("4009");
    setOutput("alias : 4009");
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                onPressed: () => Navigator.of(context).pushNamed('screen2'),
              ),
              Text(_output)
            ],
          ),
        ),
      ),
    );
  }
}
