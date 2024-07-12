import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String? _token;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color.fromARGB(255, 224, 122, 95),
          secondary: Color.fromARGB(255, 224, 122, 95),
          brightness: Brightness.light,
          onSecondary: Colors.white,
          onPrimary: Colors.white,
          onError: Colors.white,
          error: Colors.red,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        inputDecorationTheme: const InputDecorationTheme(
            focusColor: Color.fromARGB(255, 113, 133, 122),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            fillColor: Color.fromARGB(255, 244, 244, 245),
            filled: true),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 224, 122, 95),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
      home: _token != null
          ? DashboardScreen(token: _token!)
          : LoginScreen(
              setToken: (String token) => setState(() => _token = token),
            ),
    );
  }
}
