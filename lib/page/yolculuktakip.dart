import 'package:flutter/material.dart';

class YolculukTakipEkrani extends StatelessWidget {
  final Map<String, dynamic>? aktifSurucu;

  const YolculukTakipEkrani({this.aktifSurucu, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (aktifSurucu == null) {
      // Taksi çağırılmadıysa sadece uyarı göster
      return Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Text(
              "Lütfen rezervasyon oluşturunuz",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
      );
    } else {
      // Aktif sürücü bilgisi göster
      return Card(
        margin: EdgeInsets.all(16),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              // Şoför resmi
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(aktifSurucu!['resim']),
              ),
              SizedBox(width: 20),
              // Bilgiler
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${aktifSurucu!['ad']} ${aktifSurucu!['soyad']}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Plaka: ${aktifSurucu!['plaka']}",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Model: ${aktifSurucu!['arac']}",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Toplam Ücret: ${aktifSurucu!['ucret'] ?? '-'} TL",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
              // Aktif durum göstergesi
              Icon(Icons.check_circle, color: Colors.green, size: 32),
            ],
          ),
        ),
      );
    }
  }
}
