import 'package:flutter/material.dart';
import 'package:kisiler/data/entity/kisiler.dart';
import 'package:kisiler/ui/views/detay_sayfa.dart';
import 'package:kisiler/ui/views/kayit_sayfa.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyormu = false;
  List<Kisiler> kisilerListesi = [];
  List<Kisiler> tumKisilerListesi = []; // Orijinal liste

  Future<void> ara(String aramaKelimesi) async {
    setState(() {
      if (aramaKelimesi.isEmpty) {
        kisilerListesi = tumKisilerListesi; // Arama kelimesi boşsa orijinal listeyi göster
      } else {
        kisilerListesi = tumKisilerListesi.where((kisi) {
          return kisi.kisi_ad.toLowerCase().contains(aramaKelimesi.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> kisileriYukle() async {
    var kisilerData = <Kisiler>[];
    var k1 = Kisiler(kisi_id: 1, kisi_ad: "Ahmet", kisi_tel: "05054525255");
    var k2 = Kisiler(kisi_id: 2, kisi_ad: "Barış", kisi_tel: "05054525254");
    var k3 = Kisiler(kisi_id: 3, kisi_ad: "Enes", kisi_tel: "05054525252");
    kisilerData.addAll([k1, k2, k3]);

    setState(() {
      tumKisilerListesi = kisilerData; // Orijinal listeyi kaydet
      kisilerListesi = List.from(kisilerData); // Gösterilecek listeyi de aynı veriyle başlat
    });
  }

  Future<void> sil(int kisi_id) async {
    setState(() {
      kisilerListesi.removeWhere((kisi) => kisi.kisi_id == kisi_id);
      tumKisilerListesi.removeWhere((kisi) => kisi.kisi_id == kisi_id);
    });
    print("Kişiyi Sil: $kisi_id");
  }

  @override
  void initState() {
    super.initState();
    kisileriYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: aramaYapiliyormu
            ? TextField(
          decoration:  InputDecoration(hintText: "Ara"),
          onChanged: (aramaSonucu) {
            ara(aramaSonucu);
          },
        )
            : const Text("Kişiler"),
        actions: [
          aramaYapiliyormu
              ? IconButton(
              onPressed: () {
                setState(() {
                  aramaYapiliyormu = false;
                  kisilerListesi = tumKisilerListesi; // Aramadan çıkınca tüm listeyi göster
                });
              },
              icon: const Icon(Icons.clear))
              : IconButton(
              onPressed: () {
                setState(() {
                  aramaYapiliyormu = true;
                });
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: ListView.builder(
        itemCount: kisilerListesi.length,
        itemBuilder: (context, index) {
          var kisi = kisilerListesi[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetaySayfa(kisi: kisi),
                ),
              ).then((guncelKisi) {
                if (guncelKisi != null && guncelKisi is Kisiler) {
                  setState(() {
                    var index = kisilerListesi.indexWhere((k) => k.kisi_id == guncelKisi.kisi_id);
                    if (index != -1) {
                      kisilerListesi[index] = guncelKisi;
                      tumKisilerListesi[index] = guncelKisi; // Orijinal listeyi de güncelle
                    }
                  });
                }
              });
            },
            child: Card(
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kisi.kisi_ad,
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(kisi.kisi_tel),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${kisi.kisi_ad} silinsin mi?"),
                            action: SnackBarAction(
                              label: "Evet",
                              onPressed: () {
                                sil(kisi.kisi_id);
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black54,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var yeniKisi = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KayitSayfa()),
          );
          if (yeniKisi != null && yeniKisi is Kisiler) {
            setState(() {
              kisilerListesi.add(yeniKisi);
              tumKisilerListesi.add(yeniKisi); // Orijinal listeye de ekle
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
