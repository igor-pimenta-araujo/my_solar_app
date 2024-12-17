import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Solar App',
      home: LoginScreen(),
      routes: {
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}
