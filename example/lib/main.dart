import 'package:flutter/material.dart';
import 'package:rudder_sdk_flutter/RudderClient.dart';
import 'package:rudder_sdk_flutter/RudderConfig.dart';
import 'package:rudder_sdk_flutter/RudderLogger.dart';
import 'package:rudder_sdk_flutter/RudderTraits.dart';
import 'package:rudder_sdk_flutter/RudderOption.dart';
import 'package:rudder_sdk_flutter/RudderProperty.dart';

class PlatformChannel extends StatefulWidget {
  @override
  _PlatformChannelState createState() => _PlatformChannelState();
}

class _PlatformChannelState extends State<PlatformChannel> {
  void __identify() {
    RudderTraits traits = RudderTraits()
        .putName("Sai Venkat")
        .putAge("22")
        .putEmail("saivenkatdesu@gmail.com");
    RudderClient.identify("161FA04009", traits: traits);
  }

  void __track() {
    RudderProperty property = RudderProperty();
    property.put("colour", "red");
    property.put("manufacturer", "hyundai");
    property.put("model", "i20");
    RudderOption options = new RudderOption();
    options.putIntegration("All", false);
    options.putIntegration("Mixpanel", false);
    RudderClient.track("Went on a drive",
        properties: property, options: options);
  }

  void __screen() {
    RudderProperty screenProperty = new RudderProperty();
    screenProperty.put("browser", "chrome");
    screenProperty.put("device", "mac book pro");
    RudderClient.screen("Walmart Cart", properties: screenProperty);
  }

  void __group() {
    RudderTraits groupTraits = RudderTraits();
    groupTraits.put("place", "kolkata");
    groupTraits.put("size", "fiteen");
    RudderClient.group("Integrations-Rudder", groupTraits: groupTraits);
  }

  void __reset() {
    RudderClient.reset();
  }

  void __alias() {
    RudderClient.alias("4009");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('Initialize SDK'),
              onPressed: () {
                RudderConfigBuilder builder = RudderConfigBuilder();
                builder.withDataPlaneUrl("https://friendly-badger-28.loca.lt");
                builder.withControlPlaneUrl("https://56d9996d386b.ngrok.io");
                builder.withLogLevel(RudderLogger.VERBOSE);
                RudderOption options = new RudderOption();
                options.putIntegration("Amplitude", true);
                //builder.withFactory(Appcenter());
                // 1. with RudderConfig Object
                //RudderClient.getInstance("1n0JdVPZTRUIkLXYccrWzZwdGSx",
                //   config: builder.build());
                //2. With RudderConfigBuilder object
                RudderClient.getInstance("1shL9hswhzo3C0oAIfrnz8cMbjU",
                    config: builder.build(),options: options);
              },
            ),
            ElevatedButton(
              child: Text('Identify call'),
              onPressed: __identify,
            ),
            ElevatedButton(
              child: Text('Track'),
              onPressed: __track,
            ),
            ElevatedButton(
              child: Text('Screen'),
              onPressed: __screen,
            ),
            ElevatedButton(
              child: Text('Group'),
              onPressed: __group,
            ),
            ElevatedButton(
              child: Text('Reset'),
              onPressed: __reset,
            ),
            ElevatedButton(
              child: Text('Alias'),
              onPressed: __alias,
            ),
            ElevatedButton(
              child: Text('Set Anonymous Id'),
              onPressed: () {
                RudderClient.setAnonymousId("anon-user");
              },
            ),
            ElevatedButton(
              child: Text('Set Advertsing ID'),
              onPressed: () {
                RudderClient.setAdvertisingId("899jj-hguscb");
              },
            ),
            ElevatedButton(
              child: Text('Set Device Token'),
              onPressed: () {
                RudderClient.putDeviceToken("device-token-format");
              },
            )
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: PlatformChannel()));
}
