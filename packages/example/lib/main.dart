import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screen2.dart';
import 'screen3.dart';
import 'home_screen.dart';
import 'my_route_observer.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [
        MyRouteObserver(),
      ],
      home: const PlatformChannel(),
      routes: {
        'screen2': (context) => const Screen2(),
        'screen3': (context) => const Screen3(),
      },
    );
  }
}

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}
