import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class hizlierisim extends StatefulWidget {
  const hizlierisim({super.key});

  @override
  State<hizlierisim> createState() => _hizlierisimState();
}

class _hizlierisimState extends State<hizlierisim> {
  List suruculerJson = [];
  bool isLoading = true;

  // Taksi konumları (örnek, harita.dart ile aynı olmalı)
  final List<Map<String, dynamic>> taksiKonumlari = [
    {
      'position': LatLng(39.7767, 30.5206),
      'title': 'Taksi 1',
      'snippet': 'Tepebaşı - Müsait',
      "surucuId": 1,
    },
    {
      'position': LatLng(39.7721, 30.5239),
      'title': 'Taksi 2',
      'snippet': 'Tepebaşı - Müsait',
      "surucuId": 2,
    },
    {
      'position': LatLng(39.7656, 30.5210),
      'title': 'Taksi 3',
      'snippet': 'Odunpazarı - Müsait',
      "surucuId": 3,
    },
    {
      'position': LatLng(39.7690, 30.5180),
      'title': 'Taksi 4',
      'snippet': 'Odunpazarı - Müsait',
      "surucuId": 4,
    },
    {
      'position': LatLng(39.7745, 30.5145),
      'title': 'Taksi 5',
      'snippet': 'Tepebaşı - Müsait',
      "surucuId": 5,
    },
    {
      'position': LatLng(39.7612, 30.5156),
      'title': 'Taksi 6',
      'snippet': 'Odunpazarı - Müsait',
      "surucuId": 6,
    },
    {
      'position': LatLng(39.7798, 30.5289),
      'title': 'Taksi 7',
      'snippet': 'Tepebaşı - Müsait',
      "surucuId": 7,
    },
    {
      'position': LatLng(39.7634, 30.5190),
      'title': 'Taksi 8',
      'snippet': 'Odunpazarı - Müsait',
      "surucuId": 8,
    },
  ];

  LatLng? currentPosition; // Bunu harita.dart'tan veya konumdan almalısın

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    loadSuruculer();
    _getCurrentLocation();
  }

  Future<void> loadSuruculer() async {
    final String response = await rootBundle.loadString('suruculer.json');
    final data = await json.decode(response);
    setState(() {
      suruculerJson = data['suruculer'];
      isLoading = false;
    });
  }

  Map<String, dynamic>? surucuGetir(int id, List suruculerJson) {
    return suruculerJson.firstWhere((s) => s['Id'] == id, orElse: () => null);
  }

  double mesafeHesapla(LatLng konum1, LatLng konum2) {
    double mesafeMetre = Geolocator.distanceBetween(
      konum1.latitude,
      konum1.longitude,
      konum2.latitude,
      konum2.longitude,
    );
    return mesafeMetre / 1000;
  }

  List<Map<String, dynamic>> siraliTaksiListesi() {
    if (currentPosition == null) return [];
    List<Map<String, dynamic>> taksiler =
        taksiKonumlari.map((taksi) {
          final mesafe = mesafeHesapla(currentPosition!, taksi['position']);
          return {...taksi, 'mesafe': mesafe};
        }).toList();
    taksiler.sort((a, b) => a['mesafe'].compareTo(b['mesafe']));
    return taksiler;
  }

  @override
  Widget build(BuildContext context) {
    final taksiler = siraliTaksiListesi();
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
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : currentPosition == null
              ? Center(
                child: Text(
                  "Konum alınamadı. Lütfen konum izni verin ve servisi açın.",
                ),
              )
              : ListView.builder(
                itemCount: taksiler.length,
                itemBuilder: (context, index) {
                  final taksi = taksiler[index];
                  final surucu = surucuGetir(taksi['surucuId'], suruculerJson);
                  if (surucu == null) return SizedBox();
                  return Card(
                    child: ListTile(
                      leading: Image.asset(surucu['resim']),
                      title: Text('${surucu['ad']} ${surucu['soyad']}'),
                      subtitle: Text('${surucu['arac']} - ${surucu['plaka']}'),
                      trailing: Text(
                        '${taksi['mesafe'].toStringAsFixed(2)} km',
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
