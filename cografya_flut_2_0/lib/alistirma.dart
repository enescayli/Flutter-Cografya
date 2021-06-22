import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';

class AlistirmaSayfasi extends StatefulWidget {
  @override
  _AlistirmaSayfasiState createState() => _AlistirmaSayfasiState();
}

class _AlistirmaSayfasiState extends State<AlistirmaSayfasi> {
  List tumSorular = [];
  List sicaklik = [];

  int gelenIndex, maxIndex;
  int indirgenmisSicaklikMax;
  int dogruCevap;
  int birOnceki = -1;
  int soruTipi = -1;
  List<int> siklar = [];
  var siklara = [0, 0, 0, 0];

  Color _butonRenkleri;

  String soruText = "";
  String tiklananYer = "";

  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _butonRenkleri = Colors.amber.shade700;

    veriKaynaginiOku().then((soruListesi) {
      setState(() {
        tumSorular = soruListesi;
        maxIndex = tumSorular.length;
        rastgeleGetir();
      });
    });

    veriKaynaginiOkuSicaklik().then((sicaklikListesi) {
      setState(() {
        sicaklik = sicaklikListesi;
        for (int i = 0; i < sicaklik.length - 1; i++) {
          indirgenmisSicaklikMax = i;
          if (sicaklik[i]["tip"].toString() !=
              sicaklik[i + 1]["tip"].toString()) {
            break;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: tumSorular != null && tumSorular.length == maxIndex && sicaklik !=null
          ? Column(
        children: [
          Container(
            child: yigin(context),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.1,
            height: MediaQuery.of(context).size.height / 5,
            decoration: BoxDecoration(
              color: Colors.blue.shade800,

              ///     borderRadius: BorderRadius.circular(35),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70),
                bottomRight: Radius.circular(70),
                topLeft: Radius.circular(90),
                topRight: Radius.circular(90),
              ),
            ),
            child: Column(
              children: [
                Text(
                    soruText == ""
                        ? "Gösterilen ${tumSorular[gelenIndex]["tip"]} hangisidir ? "
                        : soruText,
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width/36, color: Colors.black)),
                soruTipi == 1 ?  Text("(Tıklamakta zorlanıyorsanız yakınlaştırabilirsiniz)" ,
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width/45, color: Colors.white))
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: cevaplar(),
                ),
              ],
            ),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }

  List<Widget> cevaplar() {
    if (soruTipi == 0) {
      //soruText = "Gösterilen ${tumSorular[gelenIndex]["tip"]} hangisidir ? ";

      List<ElevatedButton> temp = [];

      if (temp != null) {
        temp = [];
      }
      for (int i = 0; i < 4; i++) {
        String isim = tumSorular[siklar[i]]["isim"].toString();
        if (isim.length > 17) {
          isim = isim.substring(0, 17) + "\n" + isim.substring(17, isim.length);
        }

        temp.add(
          ElevatedButton(
            onPressed: () => tiklandi(i),
            child: Text(
              isim,
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              primary: _butonRenkleri,
              textStyle: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        );
      }
      return temp;
    }
    else if (soruTipi == 1) {
      return [Text("")];
    }
    else if (soruTipi == 2 || soruTipi == 3) {
      List<ElevatedButton> temp = [];

      if (temp != null) {
        temp = [];
      }

      for (int i = 0; i < 4; i++) {
        String isim = (i + 1).toString();// + "--"+ sicaklik[siklara[i]]["sicaklik"].toString();
        temp.add(
          ElevatedButton(
            onPressed: () => tiklandi(i),
            child: Text(
              isim,
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              primary: _butonRenkleri,
              textStyle: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        );
      }
      return temp;
    }
  }

  void tiklandi(int id) {
    {
      setState(() {
        if (id == dogruCevap) {
          rastgeleGetir();
          soruTextGuncelle();
        }
      });
    }
  }

  Stack yigin(BuildContext context) {

    return Stack(
      children: [
        InteractiveViewer(
          maxScale: 2,
          minScale: 1,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 1.3,
                child: Image.asset(
                  'assets/btn_img/turkeysd.png',
                  fit: BoxFit.fill,
                ),
              ),
              soruTipi == 0 ? poz(gelenIndex) : Text(""),
              for (int i = 0; i < 4 && soruTipi == 1; i++) poz(siklar[i]),
              for (int i = 0; i < 4 && (soruTipi == 2 || soruTipi ==3); i++) pozSic(siklara[i],i),
            ],
          ),
        ),


      ],
    );
  }

  List<Widget> children(BuildContext context) {
    return [
      Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height / 1.3,
        child: Image.asset(
          'assets/btn_img/turkeysd.png',
          fit: BoxFit.fill,
        ),
      ),
      // Poz(gelenIndex),

      /*
      for(int i =0; i<maxIndex-1; i++)
        tumSorular[i]["tip"].toString()=="Göl" ?  Poz(i) : Text(""),  */
    ];
  }

  poz(int i) {
    return pozizyonEnBoy(
      true,
      double.parse(tumSorular[i]["sol"].toString()),
      double.parse(tumSorular[i]["sag"].toString()),
      double.parse(tumSorular[i]["yuksek"].toString()),
      double.parse(tumSorular[i]["genis"].toString()),
      tumSorular[i]["path"].toString(),
      tumSorular[i]["isim"].toString(),
      tumSorular[i]["tip"].toString(),
      tumSorular[i]["tip2"].toString(),
    );
  }

  Positioned pozizyonEnBoy(bool visibility,
      double sol,
      double sag,
      double yukseklik,
      double genislik,
      String path,
      String isim,
      String tip,
      String tip2) {
    return Positioned(
      left: MediaQuery
          .of(context)
          .size
          .width / (sol * 0.1),
      top: MediaQuery
          .of(context)
          .size
          .height / (sag * 0.1),
      child: Visibility(
        visible: visibility,
        child: Container(
          width: genislik,
          height: yukseklik,
          child: InkWell(
            onTap: () {
              tiklananYer = isim;
              if (tumSorular[gelenIndex]["isim"] == isim && soruTipi == 1) {
                rastgeleGetir();
                setState(() {
                  soruTextGuncelle();
                });
              }
            },
            child: Container(
              child: Image.asset(
                path,
                //  color: gelenIndex<36 ? Colors.black.withOpacity(0.95) : Colors.deepOrange,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void soruTextGuncelle() {
    soruTipi == 0
        ? soruText = "Gösterilen ${tumSorular[gelenIndex]["tip"]} hangisidir ? "
        : soruTipi == 1 ? soruText =
    "İsmi ${tumSorular[gelenIndex]["isim"]} olan ${tumSorular[gelenIndex]["tip"]} hangisidir ?"
        : soruTipi == 2 ?
    soruText = "Hangi numara da indirgenmiş sıcaklık daha düşüktür ?"
        : soruTipi == 3 ?
    soruText = "Hangi numara da indirgenmiş sıcaklık daha yüksektir ?" : "";
  }

  Container konteynir({double yuksek, double genislik}) {
    return Container(
      width: yuksek,
      height: genislik,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(90),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
    );
  }

  Future<List> veriKaynaginiOku() async {
    var gelenJson = await DefaultAssetBundle.of(context)
        .loadString('assets/data/sorular.json');

    List soruListesi = json.decode(gelenJson.toString());

    return soruListesi;
  }

  Future<List> veriKaynaginiOkuSicaklik() async {
    var gelenJson = await DefaultAssetBundle.of(context)
        .loadString('assets/data/sicaklik.json');
    List soruListesi = json.decode(gelenJson.toString());

    return soruListesi;
  }

  void rastgeleGetir() {
    Random random = new Random();
    siklar = [-1, -1, -1, -1];

    if (soruTipi == -1) {
      soruTipi = 0;
    } else {
      soruTipi = random.nextInt(4);

    }

    if (soruTipi == 0 || soruTipi == 1) {
      int bas = 0;
      int son = 0;
      int temp = 0;
      int temp2 = 0;

      gelenIndex = random.nextInt(maxIndex);
      dogruCevap = random.nextInt(4);

      while (birOnceki == gelenIndex) {
        gelenIndex = random.nextInt(maxIndex);
      }

      temp = gelenIndex;
      temp2 = gelenIndex;

      while (temp > 0) {
        if (tumSorular[temp]["tip"].toString() ==
            tumSorular[temp - 1]["tip"].toString()) {
          temp--;
        } else
          break;
      }
      bas = temp;
      while (temp2 < maxIndex - 1) {
        if (tumSorular[temp2]["tip"].toString() ==
            tumSorular[temp2 + 1]["tip"].toString()) {
          temp2++;
        } else
          break;
      }
      son = temp2;


      for (int i = 0; i < 4; i++) {
        if (i == dogruCevap) {
          siklar[dogruCevap] = gelenIndex;
        } else {
          int sayi;
          sayi = random.nextInt(son - bas) + bas;

          /// gelenIdex' i doğru şıkka ata
          for (int j = 0; j < 4; j++) {
            if (j == dogruCevap) {
              continue;
            } else if (sayi == gelenIndex) {
              sayi = random.nextInt(son - bas) + bas;
              j = -1;
              continue;
            } else if (siklar[j] == sayi) {
              sayi = random.nextInt(son - bas) + bas;
              j = -1;
            }
          }
          siklar[i] = sayi;
        }
      }

      birOnceki = gelenIndex;
    }
    else if (soruTipi == 2 || soruTipi == 3) {
      siklara = [0, 0, 0, 0];
      for (int i = 0; i < 4; i++) {
        int sayi;
        sayi = random.nextInt(indirgenmisSicaklikMax);
        for (int j = 0; j < 4; j++) {
          if (sicaklik[siklara[j]]["sicaklik"] == sicaklik[sayi]["sicaklik"]) {
            j = -1;
            //  print("Yeni sayı üretlidi");
            sayi = random.nextInt(indirgenmisSicaklikMax);
          }
        }
        siklara[i] = sayi;
      }


      if (soruTipi == 2) {
        int enKucuk = int.parse(sicaklik[siklara[0]]["sicaklik"].toString());
        dogruCevap =0;
        for (int i = 0; i < 4; i++) {
          if (enKucuk > int.parse(sicaklik[siklara[i]]["sicaklik"].toString())){
            enKucuk = int.parse(sicaklik[siklara[i]]["sicaklik"].toString());
             dogruCevap = i;
          }
        }

      }
      if (soruTipi == 3) {
        int enBuyuk = int.parse(sicaklik[siklara[0]]["sicaklik"].toString());
        dogruCevap = 0;
        for (int i = 0; i < 4; i++) {

          if (enBuyuk < int.parse(sicaklik[siklara[i]]["sicaklik"].toString())){
            enBuyuk = int.parse(sicaklik[siklara[i]]["sicaklik"].toString());
             dogruCevap = i;
          }
        }
      }
    }
  }

  Positioned pozizyonSicaklikNoktasal(bool visibility, double sol, double sag,
      String numara, String tip, String derece) {
    return Positioned(
      left: (MediaQuery
          .of(context)
          .size
          .width ) / (sol * 0.1),
      top: MediaQuery
          .of(context)
          .size
          .height / (sag * 0.1),
      child: Visibility(
        visible: visibility,
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width / 37,
          height: MediaQuery
              .of(context)
              .size
              .width / 37,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            border: Border.all(color: Colors.black, width: 2),

            color: Colors.teal.withOpacity(0.7),
          ),
          child: InkWell(
            onTap: () {
              setState(() {

              });
            },
            child: Center(child: Text(numara,
              style: TextStyle(fontSize: MediaQuery
                  .of(context)
                  .size
                  .height / 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                //  foreground: Colors.black

              ),)),
          ),
        ),
      ),
    );
  }
  pozSic(int i, int g) {

    return pozizyonSicaklikNoktasal(
      true,
      double.parse(sicaklik[i]["sol"].toString()),
      double.parse(sicaklik[i]["sag"].toString()),
      (g+1).toString(),
      sicaklik[i]["tip"].toString(),
      sicaklik[i]["sicaklik"].toString(),
    );
  }
}
