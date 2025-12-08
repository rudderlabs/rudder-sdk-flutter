// ignore_for_file: unused_element, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdvancedUseCasesScreen extends StatefulWidget {
  const AdvancedUseCasesScreen({super.key});

  @override
  AdvancedUseCasesScreenState createState() => AdvancedUseCasesScreenState();
}

class AdvancedUseCasesScreenState extends State<AdvancedUseCasesScreen> {
  // Counter for tracking created engines
  int _engineCount = 0;

  // Text to be displayed in output
  String _output = "";

  // Method to create a new FlutterEngine (triggers onAttachedToEngine)
  Future<void> _createNewEngine() async {
    const platform = MethodChannel('test_engine_channel');
    try {
      final String result = await platform.invokeMethod('createEngine');

      _engineCount++;

      setOutput('✅ $result\n\n'
          'A new FlutterEngine was created!\n'
          'onAttachedToEngine called for ALL plugins including RudderSdkFlutterPlugin.\n\n'
          'Total engines created: $_engineCount\n\n'
          'To reproduce issue:\n'
          '1. Initialize SDK first (if not done)\n'
          '2. Click this button 2-3 times to create multiple engines\n'
          '3. Background the app (press home button)\n'
          '4. Return to the app (tap app icon to foreground)\n'
          '5. Check for NPE crash in RudderSdkFlutterPlugin\n\n'
          'Check logcat for multiple "onAttachedToEngine" messages.');
    } on PlatformException catch (e) {
      setOutput('❌ Error creating engine: ${e.message}');
    }
  }

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
                      "RudderStack Flutter SDK - Advanced Use Cases",
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
                            const Text("Testing - Reproduce Issue",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _createNewEngine,
                                    child: const Text('Create New Engine'),
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
                            const Text("Navigation",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Back to Home'),
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
