import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  Screen2State createState() => Screen2State();
}

class Screen2State extends State<Screen2> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(" This is Screen 2"),
            ElevatedButton(
                child: const Text('Go to Screen 3'),
                onPressed: () => Navigator.pushNamed(context, 'screen3')),
            ElevatedButton(
                child: const Text('Go Back to Home Screen'),
                onPressed: () => Navigator.pop(context))
          ],
        ),
      ),
    ));
  }
}
