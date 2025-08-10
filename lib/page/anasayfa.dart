import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:uber_yeni/page/aktif_card.dart';
import 'package:uber_yeni/page/hızlı_erisim.dart';
import 'package:uber_yeni/page/login.dart';
import 'package:uber_yeni/page/qrodeme.dart';
import 'package:uber_yeni/page/yolculukarim.dart';

import '../widget/harita.dart';

class Anasayfa extends StatefulWidget {
  //jsondaki kullanıcı bilgilerini alabilmek için gerekli parametreler
  //Bu parametreler, giriş yapan kullanıcının bilgilerini tutar.
  const Anasayfa({
    super.key,
    required this.userSifre,
    required this.usersoyisim,
    required this.userresim,
    required this.userisim,
  });

  final String userSifre;
  final String userisim;
  final String usersoyisim;
  final String userresim;

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  // BottomNavigationBar için gerekli değişkenler
  // Bu değişken, hangi sekmenin seçili olduğunu tutar.
  int currentIndex = 0;
  // sipariş takip için gerekli değişken.
  bool loading = false;
  List<String> resimler = [
    'resimler/slider/slider1.png',
    'resimler/slider/slider2.jpg',
    'resimler/slider/slider3.png',
    'resimler/slider/slider4.png',
  ];
  // ...

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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

        //yan menü
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.black),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          '${widget.userresim}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${widget.userisim} ${widget.usersoyisim}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Ayarlar sayfasına yönlendirme
                },
              ),
              // Boşluk bırakmak için
              Divider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Çıkış Yap'),
                    onTap: () {
                      // Çıkış işlemi
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                      // Giriş sayfasına yönlendirme
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  enlargeCenterPage: true,
                ),
                items:
                    resimler.map((resim) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Image.asset(
                              resim,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          );
                        },
                      );
                    }).toList(),
              ),
              SizedBox(height: 20),
              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 50, // Soldan boşluk
                endIndent: 50,
              ),
              SizedBox(height: 10),
              Text(
                "Konfor ve Güvenli Yolculuk",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 50, // Soldan boşluk
                endIndent: 50,
              ),
              // HARITA WİDGET'I BURAYA EKLİ
              Harita(),

              //Sipariş Takip Ekranı.
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(255, 150, 150, 150),
          currentIndex: currentIndex, // Varsayılan olarak ilk sekme seçili
          onTap: (index) {
            if (index == 0) {
              // Anasayfa - hiçbir şey yapma, zaten buradayız
              setState(() {
                currentIndex = index;
              });
            } else if (index == 1) {
              // QR Ödeme sayfasına git
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QrOdeme()),
              );
            } else if (index == 2) {
              // Yolculuklarım sayfasına git
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Yolculuklarim()),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (hizlierisim())),
              );
            }
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'QR Ödeme',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Yolcuklarım',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flash_on),
              label: 'Yakınımdakiler',
            ),
          ],
        ),
      ),
    );
  }
}
