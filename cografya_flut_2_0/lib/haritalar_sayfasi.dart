import 'dart:convert';
import 'package:cografya_flut_2_0/haritaTamSayfa.dart';
import 'package:cografya_flut_2_0/harita_getir.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HaritalarSayfasi extends StatefulWidget {
  @override
  _HaritalarSayfasiState createState() => _HaritalarSayfasiState();
}

class _HaritalarSayfasiState extends State<HaritalarSayfasi> {

  Color _renk = Colors.brown.shade900;
  List tumSorular, bilgiler;
  bool listedenGetir = true;
  bool listedenGetirTemp ;
  bool sinirGoster = false, sehirGoster = false;
  bool alakasizDeger =true;
  bool renkDegistirDurum = false;
  Color  mapRengi = Colors.red;
  String aranacakBilgi ="";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String getirelecek = "";
  String getirelecekTip = "__";
  String bilgi ="";


  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();

    veriKaynaginiOku().then((soruListesi) {
      setState(() {
        tumSorular = soruListesi;
      });
    });

    veriKaynaginiOkuBilgi().then((bilgiListesi) {
      setState(() {
        bilgiler = bilgiListesi;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    double yukseklik = MediaQuery.of(context).size.width * (0.7);
    double genislik =  MediaQuery.of(context).size.width * (3 / 4);


    listedenGetir = true;

    return  Consumer(
      builder: (context, HaritaGetir myHarita, widget)

      => Scaffold(
        key: _scaffoldKey,
        body: tumSorular != null  && bilgiler !=null ?
        Center(
          child: Row(
            children: <Widget>[
              Container(
                width: genislik,
                height: yukseklik,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 20,
                      // left: 0,
                      child: ElevatedButton(
                        onPressed: () => _scaffoldKey.currentState.openDrawer(),
                        child: Icon(Icons.arrow_right_alt_sharp,
                          size: MediaQuery.of(context).size.width/25,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 1.3,
                          /*child: Image.asset(
                            'assets/btn_img/turkeyd.png',
                            fit: BoxFit.fill,
                          ),*/
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width/70,
                              ),
                              IconButton(
                                onPressed: () {
                                  myHarita.sinirGosterGizle(sinirGoster);
                                  sinirGoster = myHarita.sinir;
                                },

                                icon: Icon(Icons.border_style,color: Colors.black,),
                                iconSize: yukseklik/10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.height / 5,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade700,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 5,),
                                    Text(
                                        "$getirelecek",
                                        style: TextStyle(fontSize: yukseklik/20, color: Colors.white)),
                                    SizedBox(height: 5,),
                                    Expanded(
                                      child: Text(
                                          "$getirelecekTip",
                                          style: TextStyle(fontSize: yukseklik/30, color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                    InteractiveViewer(
                      maxScale: 4,
                      minScale: 1,
                      /// Harita kısmını bir arada tutan stack...
                      ///   ↓↓↓↓↓  ↓↓↓↓↓  ↓↓↓↓↓  ↓↓↓↓↓  ↓↓↓↓↓
                      child: Stack(
                        children: [
                          Stack(
                            children: [
                              Image.asset(
                                myHarita.resimKaynagi,
                                width: genislik,
                                height: MediaQuery.of(context).size.height / 1.3,
                                fit: BoxFit.fill,

                                //  fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          sinirGoster ?  Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.3,
                            child: Image.asset(
                             // 'assets/haritalar/my/sinir.png',
                              'assets/haritalar/my/sinir1.png',
                              fit: BoxFit.fill,
                            ),
                          ) : Text(""),

                          for(int i =0; i< tumSorular.length -1; i++)
                            tumSorular[i]["tip"].toString()==getirelecek  && listedenGetir ?   poz(i) : Text(""),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              haritaListesi(context, myHarita),
            ],
          ),
        ) : Center(child: CircularProgressIndicator()),

        drawer:  tumSorular != null  && bilgiler !=null ?
        Container(
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.6),
            border: Border.all(width: 3, color: Colors.teal.shade900),
            borderRadius: BorderRadius.circular(40),
          ),
          width: MediaQuery.of(context).size.width/1.2,
         child: ListView(
           padding: EdgeInsets.zero,
           children: <Widget>[
             ListTile(
               title: Center(child: Text(aranacakBilgi,
                 style: TextStyle(fontSize: MediaQuery.of(context).size.width/24,color: Colors.white),)),
             ),
             Divider(thickness: 4, color: Colors.black,
               indent: MediaQuery.of(context).size.width/6.5,
               endIndent: MediaQuery.of(context).size.width/6.5,),
             ListTile(
               title: Center(child: bilgiGetir()),
             ),
           ],
         ),
        ) : Text(""),
      ),
    );
  }



  Text bilgiGetir()  {

    bool temp = false;
    String madde ="madde";
    bilgi ="";

    for(int i=0; i< bilgiler.length; i++) {
      if(bilgiler[i]["isim"].toString() == aranacakBilgi) {
        temp =true;
        int len = (bilgiler[i] as Map<dynamic, dynamic>).length;

        for(int j = 1; j< len-1; j++ ) {
          madde = "madde" + j.toString();
          bilgi += bilgiler [i][madde].toString();
        }
        break;
      }
    }
    if(temp)  return  Text(bilgi, style: TextStyle(fontSize:  MediaQuery.of(context).size.width/34),);
     else return Text("");

   }


  Container haritaListesi(BuildContext context, HaritaGetir myHarita) {
    return Container(
      child: Expanded(
        child: SingleChildScrollView(
          child: ListView(
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: cocuklar(context, myHarita),
          ),
        ),
      ),
    );
  }

  String cardParentIsim ="";

  Card haritaCardLinkOlustur({String isim, List cocuklar}) {

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ExpansionTile(
            childrenPadding: EdgeInsets.all(5),
            expandedAlignment: Alignment.center,
            title: Text(
              isim,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: _renk,
            collapsedBackgroundColor: _renk,
            children: [
              for (int i = 0; i < cocuklar.length; i++) cocuklar[i],
            ],
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  InkWell cardCocukLink(
      {String ustIsim, String isim, String adres, BuildContext context, HaritaGetir myHarita}) {
    return InkWell(
      onTap: () {
        getirelecekTip = isim;
        getirelecek = ustIsim;
        aranacakBilgi =isim;

        myHarita.resimGuncelle(adres);
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(0),
        color: _renk,
        child: Column(
          children: [
            Text(
              isim,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Divider(
              color: Colors.white,
              thickness: 1,
              endIndent: 0.2,
            ),
          ],
        ),
      ),
    );
  }


  Container haritaLinkiOlustur(
      {String isim, String adres, BuildContext context, HaritaGetir myHarita}) {


    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.height * 0.7,
            height: MediaQuery.of(context).size.height * 0.1,
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: _renk,

            child: InkWell(
              onTap: () {
                getirelecekTip = "__";
                getirelecek = isim;
                aranacakBilgi =isim;
                listedenGetir = false;
                myHarita.resimGuncelle(adres);
              },
              child: Text(
                isim,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),


          ),
          SizedBox(height: 10,),
        ],
      ),
    ); }


  List<Widget> cocuklar(BuildContext context, HaritaGetir myHarita) {
    return [
      listedenLinkOlustur("Ova", context, myHarita ),
      listedenLinkOlustur("Plato", context, myHarita),
      listedenLinkOlustur("Göl", context, myHarita),
      listedenLinkOlustur("Dağ", context, myHarita),
      haritaLinkiOlustur( isim: "Afetler", adres: "assets/haritalar/my/dogal_afet_m.png",  context: context, myHarita: myHarita),
      haritaLinkiOlustur( isim: "İklim", adres: "assets/haritalar/my/iklim.png",  context: context, myHarita: myHarita),
      haritaLinkiOlustur( isim: "Çözünme", adres: "assets/haritalar/my/cozunme.png",  context: context, myHarita: myHarita),
      haritaLinkiOlustur( isim: "Deprem", adres: "assets/haritalar/my/deprem.png",  context: context, myHarita: myHarita),
      haritaLinkiOlustur( isim: "Kıyı tipi", adres: "assets/haritalar/my/kiyi_tipi_m.png",  context: context, myHarita: myHarita),
      haritaLinkiOlustur( isim: "Nüfus", adres: "assets/haritalar/my/nufus_m.png",  context: context, myHarita: myHarita),
      haritaLinkiOlustur( isim: "İndirgenmiş Sıcaklık", adres: "assets/haritalar/my/IndirgenmisSicaklik.png",  context: context, myHarita: myHarita),


      haritaCardLinkOlustur(
        isim: "Tahıllar",
        cocuklar: [
          cardCocukLink(ustIsim :"Tahıl", isim: "Arpa", adres: "assets/haritalar/my/arpa.png", context: context, myHarita: myHarita,),
          cardCocukLink(ustIsim :"Tahıl", isim: "Buğday", adres: "assets/haritalar/my/bugday.png", context: context, myHarita: myHarita,),
          cardCocukLink(ustIsim :"Tahıl", isim: "Çavdar", adres: "assets/haritalar/my/cavdar.png", context: context, myHarita: myHarita,),
         // cardCocukLink(ustIsim :"Tahıl", isim: "Mısır", adres: "assets/haritalar/my/misir.png", context: context, myHarita: myHarita,),
          cardCocukLink(ustIsim :"Tahıl", isim: "Çeltik", adres: "assets/haritalar/my/celtik.png", context: context, myHarita: myHarita,),
        ],
      ),

      
      haritaCardLinkOlustur(
        isim: "Bitki",
        cocuklar: [
          cardCocukLink(ustIsim :"Bitki", isim: "Ayçiçeği", adres: "assets/haritalar/my/ayicek.png", context: context, myHarita: myHarita,),
          cardCocukLink(ustIsim :"Bitki", isim: "Çay", adres: "assets/haritalar/my/cay.png", context: context, myHarita: myHarita,),
          cardCocukLink(ustIsim :"Bitki", isim: "Pamuk", adres: "assets/haritalar/my/pamuk.png", context: context, myHarita: myHarita,),
          cardCocukLink(ustIsim :"Bitki", isim: "Şeker Pancarı", adres: "assets/haritalar/my/sekerPancari.png", context: context, myHarita: myHarita,),
          cardCocukLink(ustIsim :"Bitki", isim: "Tütün", adres: "assets/haritalar/my/tutun.png", context: context, myHarita: myHarita,),
          cardCocukLink(ustIsim :"Bitki", isim: "Zeytin", adres: "assets/haritalar/my/zeytin.png", context: context, myHarita: myHarita,),
        ],
      ),


      haritaCardLinkOlustur(
        isim: "Meyve",
        cocuklar: [
          cardCocukLink(ustIsim :"Meyve", isim: "Elma", adres: "assets/haritalar/my/elma.png", context: context, myHarita: myHarita,),
       // cardCocukLink(ustIsim :"Meyve", isim: "Fındık", adres: "assets/haritalar/my/findik.jpg", context: context, myHarita: myHarita,),
          cardCocukLink(ustIsim :"Meyve", isim: "İncir", adres: "assets/haritalar/my/incir.png", context: context, myHarita: myHarita,),
          cardCocukLink(ustIsim :"Meyve", isim: "Kayısı", adres: "assets/haritalar/my/kayisi.png", context: context, myHarita: myHarita,),
          cardCocukLink(ustIsim :"Meyve", isim: "Üzüm(Çekirdeksiz)", adres: "assets/haritalar/my/cekirdeksizUzum.png", context: context, myHarita: myHarita,),
        ],
      ),

      haritaCardLinkOlustur(
        isim: "Hayvancılık",
        cocuklar: [
          cardCocukLink(ustIsim :"Hayvancılık", isim: "Büyükbaş", adres: "assets/haritalar/my/buyukbas.png", context: context, myHarita: myHarita,),
          cardCocukLink(ustIsim :"Hayvancılık", isim: "Küçükbaş", adres: "assets/haritalar/my/kucukbas.png", context: context, myHarita: myHarita,),
        //  cardCocukLink(ustIsim :"mycılık", isim: "İpek Böceği", adres: "assets/my/ipek_bocegi.png", context: context, myHarita: myHarita,),
        //  cardCocukLink(ustIsim :"mycılık", isim: "Kümes", adres: "assets/haritalar/my/kumes.png", context: context, myHarita: myHarita,),
        ],
      ),

    ];
  }

  Container listedenLinkOlustur(String isim ,BuildContext context, HaritaGetir myHarita) {

    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.height /1.3,
            height: MediaQuery.of(context).size.height * 0.1,
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: _renk,
            child: InkWell(
              onTap: () {
               myHarita.resimGuncelle("assets/btn_img/turkeyd.png");
                setState(() {
                  getirelecekTip ="__";
                  getirelecek =  isim;
                  listedenGetir = true;
                  aranacakBilgi =isim;
                  if(oncekiNumara != -1)  {
                    tumSorular[oncekiNumara]["renk"] = null;
                  }
                });

                //   for(int i = 0; i<tumSorular.length-1; i++)
                //Poz(0);
                // tumSorular[i]["tip"].toString()=="Göl" ?  Poz(i) : Text("m");
              },
              child: Text(
                isim,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
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
      i,
      null,
    );
  }


  int oncekiNumara = -1;

  Positioned pozizyonEnBoy(bool visibility,double sol, double sag, double yukseklik,
      double genislik, String path, String isim, String tip, String tip2,int numara,Color renk) {


    return Positioned(
      left: (MediaQuery.of(context).size.width/1.33) / (sol * 0.1),
      top: MediaQuery.of(context).size.height / (sag * 0.1),
      child: Visibility(
        visible: visibility,
        child: Container(
          width:   ((genislik/1.3)  * MediaQuery.of(context).size.width/820.571) ,
          height:  ((yukseklik)  * MediaQuery.of(context).size.height/411.428),
          child: InkWell(
            onTap: () {
              ("Önceki numara = > $oncekiNumara");
              if(oncekiNumara == -1)  {
                oncekiNumara = numara;
              }
              if(oncekiNumara != -1)  {
                tumSorular[oncekiNumara]["renk"] = null;
              }
              tumSorular[numara]["renk"] = Colors.red;
              oncekiNumara = numara;

              (isim);
              (tip);
              getirelecekTip = isim +" ("+ tip2 +")" ;
              renkDegistirDurum = !renkDegistirDurum;
              setState(() {

              });
            },
            child: Container(
              child: Image.asset(
                path,
                fit: BoxFit.fill,
                color : tumSorular[numara]["renk"],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<List> veriKaynaginiOku() async {
    /* Future<String> jsonOku = DefaultAssetBundle.of(context).loadString('assets/data/sorular.json');

   jsonOku.then((okunanJson) {
     debug("gelen json: " +okunanJson);
     return okunanJson;
   });*/

    var gelenJson = await DefaultAssetBundle.of(context)
        .loadString('assets/data/sorular.json');

    List soruListesi = json.decode(gelenJson.toString());

    return soruListesi;
  }
  Future<List> veriKaynaginiOkuBilgi() async {

    var gelenJson = await DefaultAssetBundle.of(context)
        .loadString('assets/data/bilgiler.json');

    List bilgiListesi = json.decode(gelenJson.toString());

    return bilgiListesi;
  }

}