import 'package:file_pick_animation/test.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_api_intregrations/Features/auth/login/presentation/screens/login_screen.dart';

void main() {   
  runApp(const  MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Basketball Upload Animation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEE5A24)),
        useMaterial3: true,
      ),
      home: const Test(),
    );
  }
}
