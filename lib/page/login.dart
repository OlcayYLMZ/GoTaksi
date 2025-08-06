import 'package:flutter/material.dart';
import 'package:uber_yeni/page/anasayfa.dart';
import 'package:uber_yeni/page/kayıt.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var isim = TextEditingController();
  var sifre = TextEditingController();

  girisKontrol() async {
    var jsonString = await rootBundle.loadString("kayıtlı_kişiler.json");
    var jsonData = json.decode(jsonString);

    //kişiler json dosyamızdaki kişileri listeye aldık.
    List kisilerList = jsonData["kisiler"];

    //TextEditing de girilen bilgileri aldık
    String girilenIsim = isim.text;
    String girilenSifre = sifre.text;

    //Kişiler listesini kontrol ettiriyoruz.
    for (var kisi in kisilerList) {
      if (kisi["isim"] == girilenIsim && kisi["sifre"] == girilenSifre) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Anasayfa(
                  userisim: kisi["isim"],
                  usersoyisim: kisi["soyisim"],
                  userresim: kisi["resim"],
                  userSifre: kisi["sifre"],
                ),
          ),
        );
        return; // Giriş başarılı, döngüden çık
      }
    }
    // Eğer giriş başarısızsa, kullanıcıya hata mesajı göster
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Kullanıcı adı veya şifre yanlış!"),
        backgroundColor: Colors.red,
      ),
    );
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
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 5),
                ),
                child: ClipOval(
                  child: Image.asset('resimler/logo.png', fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 60),
              TextField(
                controller: isim,
                decoration: InputDecoration(
                  labelText: 'İsim',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: sifre,
                decoration: InputDecoration(
                  labelText: 'Sifre',

                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),

              // GİRİŞ VE KAYIT OL BUTONLARI
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Giriş Yap"),
                    onPressed: () {
                      girisKontrol();
                    },
                  ),
                  SizedBox(height: 20),
                  //kayıt ol butonu
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => kayit()),
                      );
                    },
                    child: Text("Kayıt Ol"),
                  ),
                  SizedBox(height: 30),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Şifremi Unuttum?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
