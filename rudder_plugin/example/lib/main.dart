import 'package:flutter/material.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_sdk_flutter/RudderController.dart';

class PlatformChannel extends StatefulWidget {
  const PlatformChannel({Key? key}) : super(key: key);

  @override
  _PlatformChannelState createState() => _PlatformChannelState();
}

class _PlatformChannelState extends State<PlatformChannel> {
  final RudderController rudderClient = RudderController.instance;

  void __identify() {
    RudderTraits traits = RudderTraits()
        .putName("Sai Venkat")
        .putAge("22")
        .putEmail("saivenkatdesu@gmail.com");
    rudderClient.identify("161FA04009", traits: traits);
    setOutput("identify : \nname:Sai Venkat\nage: 22\nemail:saivenkatdesu@gmail.com"
        "\nuserId: 161FA04009\ntraits:empty");
  }

  void __initialize() {
    RudderConfigBuilder builder = RudderConfigBuilder();
    builder
        .withDataPlaneUrl("https://rudderstacgwyx.dataplane.rudderstack.com");
    builder.withControlPlaneUrl("https://api.rudderlabs.com");
    builder.withLogLevel(RudderLogger.VERBOSE);
    RudderOption options = RudderOption();
    options.putIntegration("Amplitude", true);
    //builder.withFactory(Appcenter());
    // 1. with RudderConfig Object
    //RudderClient.getInstance("1n0JdVPZTRUIkLXYccrWzZwdGSx",
    //   config: builder.build());
    //2. With RudderConfigBuilder object
    final String _writeKey = "25YL7MIwWWL3HPeEFT53GI5MxVh";
    rudderClient.initialize(_writeKey,
        config: builder.build(), options: options);

    setOutput("initialize:\nwriteKey: $_writeKey");
  }

  void __track() {
    RudderProperty property = RudderProperty();
    property.put("colour", "red");
    property.put("manufacturer", "hyundai");
    property.put("model", "i20");
    RudderOption options = RudderOption();
    options.putIntegration("All", false);
    options.putIntegration("Mixpanel", false);
    rudderClient.track("Went on a drive",
        properties: property, options: options);

    setOutput("track:\n\tproperty:\n\t\tcolour:red\n\t\tmanufacturer:hyundai\n\t\tmodel:i20"
        "\n\toptions:\n\t\tall:false\n\t\tMixpanel:false\n\tevent: Went on a drive");
  }

  void __screen() {
    RudderProperty screenProperty = RudderProperty();
    screenProperty.put("browser", "chrome");
    screenProperty.put("device", "mac book pro");
    rudderClient.screen("Walmart Cart", properties: screenProperty);

    setOutput("screen:\n\tproperty:\n\t\tbrowser: chrome\n\t\tdevice: mac book pro\n\t\tname:Walmart Cart");
  }

  void __optOut() {
    rudderClient.optOut(true);
  }

  void __optIn() {
    rudderClient.optOut(false);
  }

  void __group() {
    RudderTraits groupTraits = RudderTraits();
    groupTraits.put("place", "kolkata");
    groupTraits.put("size", "fifteen");
    rudderClient.group("Integrations-Rudder", groupTraits: groupTraits);
    setOutput("group\n\ttraits:\n\t\tplace:kolkata\n\t\tsize:fifteen\n\tid: Integrations-Rudder");
  }

  void __reset() {
    rudderClient.reset();
    setOutput("reset");
  }

  void __alias() {
    rudderClient.alias("4009");
    setOutput("alias : 4009");
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
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: const Text('Initialize SDK'),
              onPressed: () {
                __initialize();
              },
            ),
            ElevatedButton(
              child: const Text('Identify call'),
              onPressed: __identify,
            ),
            ElevatedButton(
              child: const Text('Track'),
              onPressed: __track,
            ),
            ElevatedButton(
              child: const Text('Screen'),
              onPressed: __screen,
            ),
            ElevatedButton(
              child: const Text('Group'),
              onPressed: __group,
            ),
            ElevatedButton(
              child: const Text('Reset'),
              onPressed: __reset,
            ),
            ElevatedButton(
              child: const Text('Alias'),
              onPressed: __alias,
            ),
            ElevatedButton(
              child: const Text('Rudder Context'),
              onPressed: () async {
                Map? context = await rudderClient.getRudderContext();
                print(context);
              },
            ),
            ElevatedButton(
              child: const Text('Set Advertsing ID'),
              onPressed: () {
                rudderClient.putAdvertisingId("899jj-hguscb");
              },
            ),
            ElevatedButton(
              child: const Text('Set Device Token'),
              onPressed: () {
                rudderClient.putDeviceToken("device-token-format");
              },
            ),
            Text(_output)
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: PlatformChannel()));
}
