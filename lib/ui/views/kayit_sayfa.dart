import 'package:flutter/material.dart';
import 'package:kisiler/data/entity/kisiler.dart';

class KayitSayfa extends StatefulWidget {
  const KayitSayfa({super.key});

  @override
  State<KayitSayfa> createState() => _KayitSayfaState();
}

class _KayitSayfaState extends State<KayitSayfa> {
  var tfKisiAdi = TextEditingController();
  var tfKisiTel = TextEditingController();

  Future<void> kaydet() async {
    var kisi_ad = tfKisiAdi.text;
    var kisi_tel = tfKisiTel.text;

    if (kisi_ad.isNotEmpty && kisi_tel.isNotEmpty) {
      // Yeni kişi bilgilerini oluştur
      var yeniKisi = Kisiler(
        kisi_id: DateTime.now().millisecondsSinceEpoch,
        kisi_ad: kisi_ad,
        kisi_tel: kisi_tel,
      );

      // Yeni kişiyi geri döndür
      Navigator.pop(context, yeniKisi);
    } else {
      // Alanlar boşsa hata mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Kayıt Sayfa")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: tfKisiAdi,
                decoration: const InputDecoration(hintText: "Kişi Adı"),
              ),
              TextField(
                controller: tfKisiTel,
                decoration: const InputDecoration(hintText: "Kişi Tel"),
                keyboardType: TextInputType.phone,
              ),
              ElevatedButton(
                onPressed: kaydet,
                child: const Text("KAYDET"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
