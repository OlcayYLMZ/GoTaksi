import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class SurucuListesi extends StatefulWidget {
  const SurucuListesi({super.key});

  @override
  State<SurucuListesi> createState() => _SurucuListesiState();
}

class _SurucuListesiState extends State<SurucuListesi> {
  List<dynamic> suruculer = [];

  @override
  void initState() {
    super.initState();
    _suruculeriYukle();
  }

  Future<void> _suruculeriYukle() async {
    String jsonString = await rootBundle.loadString('suruculer.json');
    final jsonData = json.decode(jsonString);
    setState(() {
      suruculer = jsonData['suruculer'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suruculer.length,
      itemBuilder: (context, index) {
        final surucu = suruculer[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            leading:
                surucu['resim'] != null
                    ? Image.asset(
                      surucu['resim'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                    : Icon(Icons.person, size: 50),
            title: Text("${surucu['ad'] ?? ''} ${surucu['soyad'] ?? ''}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID: ${surucu['Id'] ?? ''}"),
                Text("Araç: ${surucu['arac'] ?? ''}"),
                Text("Plaka: ${surucu['plaka'] ?? ''}"),
                Text("Ücret: ${surucu['ucret'] ?? ''} TL"),
              ],
            ),
          ),
        );
      },
    );
  }
}
