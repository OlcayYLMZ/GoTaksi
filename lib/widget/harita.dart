import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uber_yeni/page/surucu_detay.dart';

class Harita extends StatefulWidget {
  const Harita({super.key});

  @override
  State<Harita> createState() => _HaritaState();
}

class _HaritaState extends State<Harita> {
  GoogleMapController? mapController;
  LatLng? currentPosition;
  bool isLoading = true;
  Set<Marker> _markers = {};
  StreamSubscription<Position>?
  _positionStreamSubscription; // Canlı konum dinleyicisi

  // Eskişehir Tepebaşı ve Odunpazarı bölgelerindeki hayali taksi konumları
  final List<Map<String, dynamic>> taksiKonumlari = [
    {
      'position': LatLng(39.7767, 30.5206), // Tepebaşı Merkez
      'title': 'Taksi 1',
      'snippet': 'Tepebaşı - Müsait',
      "surucuId": 1, // Sürücü ID'si
    },
    {
      'position': LatLng(39.7721, 30.5239), // Anadolu Üniversitesi yakını
      'title': 'Taksi 2',
      'snippet': 'Tepebaşı - Müsait',
      "surucuId": 2, // Sürücü ID'si
    },
    {
      'position': LatLng(39.7656, 30.5210), // Odunpazarı Merkez
      'title': 'Taksi 3',
      'snippet': 'Odunpazarı - Müsait',
      "surucuId": 3, // Sürücü ID'si
    },
    {
      'position': LatLng(39.7690, 30.5180), // Kurşunlu Külliyesi yakını
      'title': 'Taksi 4',
      'snippet': 'Odunpazarı - Müsait',
      "surucuId": 4, // Sürücü ID'si
    },
    {
      'position': LatLng(39.7745, 30.5145), // Espark yakını
      'title': 'Taksi 5',
      'snippet': 'Tepebaşı - Müsait',
      "surucuId": 5, // Sürücü ID'si
    },
    {
      'position': LatLng(39.7612, 30.5156), // Odunpazarı Evleri yakını
      'title': 'Taksi 6',
      'snippet': 'Odunpazarı - Müsait',
      "surucuId": 6, // Sürücü ID'si
    },
    {
      'position': LatLng(39.7798, 30.5289), // Gar bölgesi
      'title': 'Taksi 7',
      'snippet': 'Tepebaşı - Müsait',
      "surucuId": 7, // Sürücü ID'si
    },
    {
      'position': LatLng(39.7634, 30.5190), // Hamamyolu yakını
      'title': 'Taksi 8',
      'snippet': 'Odunpazarı - Müsait',
      "surucuId": 8, // Sürücü ID'si
    },
  ];

  void _createTaksiMarkers() {
    _markers.clear();
    for (int i = 0; i < taksiKonumlari.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('taksi_$i'),
          position: taksiKonumlari[i]['position'],
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow,
          ),
          onTap: () {
            // Sürücü detay sayfasına git
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        SurucuDetay(surucuId: taksiKonumlari[i]['surucuId']),
              ),
            );
          },
          infoWindow: InfoWindow(
            title: taksiKonumlari[i]['title'],
            snippet: taksiKonumlari[i]['snippet'],
          ),
        ),
      );
    }
  }

  void _startLiveLocationTracking() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 10 metre hareket ettiğinde güncelle
      ),
    ).listen((Position position) {
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });

      // Kamerayı yeni konuma hareket ettir
      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(currentPosition!));
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();

        setState(() {
          currentPosition = LatLng(position.latitude, position.longitude);
          isLoading = false;
        });

        // Canlı takibi başlat
        _startLiveLocationTracking();

        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLng(currentPosition!),
          );
        }
      }
    } catch (e) {
      print("Konum alınamadı: $e");
      setState(() {
        isLoading = false;
      });
    }
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
    return mesafeMetre / 1000; // kilometre cinsinden döndürür
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
  void initState() {
    super.initState();
    _getCurrentLocation();
    _createTaksiMarkers(); // Taksi marker'larını oluştur
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel(); // Canlı konum dinleyicisini durdur
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 200, // Harita yüksekliği
      width: 380,
      child:
          isLoading
              ? Center(
                child: CircularProgressIndicator(),
              ) // Konum yüklenirken loading göster
              : GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                  // Harita yüklenince gerçek konuma git
                  if (currentPosition != null) {
                    mapController!.animateCamera(
                      CameraUpdate.newLatLng(currentPosition!),
                    );
                  }
                },
                initialCameraPosition: CameraPosition(
                  target:
                      currentPosition ??
                      LatLng(40.1828, 29.0665), // Bursa koordinatları
                  zoom: 13.0, // Şehir içi detayı için zoom artırıldı
                ),
                markers: _markers, // Taksi marker'larını ekle
                myLocationEnabled: true, // Kullanıcı konumu göster
                myLocationButtonEnabled: true, // Konum butonu göster
                mapType: MapType.normal, // Harita tipi
              ),
    );
  }
}
