import 'package:flutter/material.dart';

class hizlierisim extends StatefulWidget {
  const hizlierisim({super.key});

  @override
  State<hizlierisim> createState() => _hizlierisimState();
}

class _hizlierisimState extends State<hizlierisim> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "GoTaksi",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
