import 'package:flutter/material.dart';
import 'package:uber_yeni/page/anasayfa.dart';
import 'package:uber_yeni/page/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
