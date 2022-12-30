import 'package:flutter/material.dart';

class Screen3 extends StatefulWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  Screen3State createState() => Screen3State();
}

class Screen3State extends State<Screen3> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("This is Screen 3"),
            ElevatedButton(
              child: const Text('Go back to Screen 2'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    ));
  }
}
