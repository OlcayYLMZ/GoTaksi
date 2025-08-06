import 'package:flutter/material.dart';

class QrOdeme extends StatefulWidget {
  const QrOdeme({super.key});

  @override
  State<QrOdeme> createState() => _QrOdemeState();
}

class _QrOdemeState extends State<QrOdeme> {
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
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.qr_code_scanner,
                size: 120,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            Text(
              "QR Kod ile Ödeme",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Kamerayı QR koda tutarak ödeme yapabilirsiniz",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                // QR kod tarama işlemi
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("QR Kod tarayıcı açılıyor...")),
                );
              },
              icon: Icon(Icons.camera_alt),
              label: Text("QR Kod Tara"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
