import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SurucuDetay extends StatefulWidget {
  final int surucuId; // Hangi sürücünün detayını göstereceğiz

  const SurucuDetay({super.key, required this.surucuId});

  @override
  State<SurucuDetay> createState() => _SurucuDetayState();
}

class _SurucuDetayState extends State<SurucuDetay> {
  Map<String, dynamic>? surucuBilgisi;
  bool isLoading = true;

  // JSON'dan sürücü bilgisini al
  Future<void> surucuBilgisiAl() async {
    try {
      String jsonString = await rootBundle.loadString('suruculer.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);

      List surucuList = jsonData['suruculer'];

      // ID'ye göre sürücüyü bul
      for (var surucu in surucuList) {
        if (surucu['Id'] == widget.surucuId) {
          setState(() {
            surucuBilgisi = surucu;
            isLoading = false;
          });
          return;
        }
      }
      setState(() {
        surucuBilgisi = null;
        isLoading = false;
      });
    } catch (e) {
      print("Hata: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    surucuBilgisiAl();
  }

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
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : surucuBilgisi == null
              ? Center(child: Text("Sürücü bulunamadı"))
              : Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Sürücü kartı
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Image.asset(
                              "${surucuBilgisi!['resim']}",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "${surucuBilgisi!['ad']} ${surucuBilgisi!['soyad']}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              surucuBilgisi!['arac'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              surucuBilgisi!['plaka'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Çağır butonu
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        // Taksi çağırma işlemi
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${surucuBilgisi!['ad']} çağrıldı!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Text(
                        "TAKSİ ÇAĞIR",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
