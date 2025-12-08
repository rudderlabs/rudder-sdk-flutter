import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home_screen.dart';
import 'screen2.dart';
import 'screen3.dart';
import 'advanced_use_cases_screen.dart';
import 'my_route_observer.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [
        MyRouteObserver(),
      ],
      home: const HomeScreen(),
      routes: {
        'screen2': (context) => const Screen2(),
        'screen3': (context) => const Screen3(),
        'home_screen': (context) => const HomeScreen(),
        'advanced_use_cases': (context) => const AdvancedUseCasesScreen(),
      },
    );
  }
}

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}
