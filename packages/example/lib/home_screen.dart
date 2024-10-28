// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rudder_sdk_flutter/RudderController.dart';
import 'package:rudder_integration_kochava_flutter/rudder_integration_kochava_flutter.dart';
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
    rudderClient.identify("161FA04009");
    setOutput("identify : \nuserId: 161FA04009\ntraits:empty");
  }

  void __initialize() {
    MobileConfig mc = MobileConfig(gzip: false, trackLifecycleEvents: false);
    RudderConfigBuilder builder = RudderConfigBuilder();
    builder
      ..withFactory(RudderIntegrationKochavaFlutter())
      ..withDataPlaneUrl(
          dotenv.env['DATA_PLANE_URL'] ?? "https://hosted.rudderlabs.com")
      ..withMobileConfig(mc)
      ..withLogLevel(RudderLogger.VERBOSE)
      ..withDataResidencyServer(DataResidencyServer.US);
    String writeKey = dotenv.env['WRITE_KEY'] ?? "INVALID_WRITE_KEY";
    rudderClient.initialize(writeKey, config: builder.build(), options: null);
    isInitialized = true;

    setOutput("initialize:\nwriteKey: $writeKey");
  }

  void __track() {
    rudderClient.track(
      "Order Completed",
      properties: RudderProperty()
        ..put("products", getMultipleProductsAsList())
        ..put("revenue", 8.99)
        ..put("currency", "USD")
        ..put("quantity", 2)
        ..put("order_id", "order123")
        ..put("checkout_id", "check123")
        ..put("custom_1", "string")
        ..put("custom_2", 1230)
        ..put("custom_3", true),
    );

    rudderClient.track(
      "Order Completed",
      properties: RudderProperty()
        ..put("products", getSingleProductsAsJSON())
        ..put("revenue", 14)
        ..put("currency", "USD")
        ..put("quantity", 1)
        ..put("sku", "G-32")
        ..put("productId", 123),
    );

    rudderClient.track(
      "Checkout Started",
      properties: RudderProperty()
        ..put("products", getMultipleProductsAsList())
        ..put("currency", "USD")
        ..put("order_id", "order123")
        ..put("product_id", "pro123")
        ..put("custom_1", "string")
        ..put("custom_2", 1230)
        ..put("custom_3", true),
    );

    rudderClient.track(
      "Product Added to Wishlist",
      properties: RudderProperty()
        ..put("name", "Gold")
        ..put("quantity", 678),
    );

    rudderClient.track(
      "Product Added",
      properties: RudderProperty()
        ..put("product_id", "product_001")
        ..put("name", "Gold")
        ..put("quantity", 678),
    );

    rudderClient.track(
      "product reviewed",
      properties: RudderProperty()..put("rating", 5),
    );

    rudderClient.track(
      "products searched",
      properties: RudderProperty()..put("query", "www.facebook.com"),
    );

    rudderClient.track("Custom track event");
  }

  void __screen() {
    RudderProperty screenProperty = RudderProperty();
    screenProperty
      ..put("key-1", "value-1")
      ..put("key-2", 200);
    rudderClient.screen("RS Screen Event",
        category: "home", properties: screenProperty, options: null);
  }

  void __reset() {
    rudderClient.reset(clearAnonymousId: true);
    setOutput("reset");
  }

//text to be displayed
  String _output = "";

  void setOutput(String text) {
    setState(() {
      _output = "output - $text";
    });
  }

  List<Map<String, dynamic>> getMultipleProductsAsList() {
    final Map<String, dynamic> product1 = {
      "product_id": "pro1",
      "name": "monopoly"
    };

    final Map<String, dynamic> product2 = {
      "product_id": "pro2",
      "name": "games"
    };

    return [product1, product2];
  }

  List<Map<String, dynamic>> getSingleProductsAsJSON() {
    final Map<String, dynamic> product1 = {
      "product_id": 123.87,
      "name": "Monopoly"
    };

    return [product1];
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
                      onPressed: __reset,
                      child: const Text('Reset'),
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
