import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KonuAnlatimi extends StatefulWidget {
  @override
  _KonuAnlatimiState createState() => _KonuAnlatimiState();
}

class _KonuAnlatimiState extends State<KonuAnlatimi> {

  List bilgiler = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    veriKaynaginiOkuBilgi().then((bilgiListesi) {
      setState(() {
        bilgiler = bilgiListesi;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return bilgiler != null && bilgiler.length != 0 ? Scaffold(
      body: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: bilgiler.length,
           itemBuilder: (context, index)  {
            return Card(
              color:  index %2 == 0 ? Colors.teal.shade600 : Colors.yellow.shade700,
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    title: Center(
                      child: Text(bilgiler[index]["isim"].toString(), style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/17,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 5.0,
                            offset: Offset(0.0, 3.0),
                          ),
                        ],
                      ), ),
                    ),
                    subtitle: bilgileriGetirText(index),
                  ),
                  InteractiveViewer(
                    minScale: 1,
                    maxScale: 2,
                    child: resimKaynagi(context, index),
                  ),
                ],
              ),
            );
           },

      ),
    ) : Center(child: CircularProgressIndicator(),);
  }

  Container resimKaynagi(BuildContext context, int index) {
    if(bilgiler [index]["path"] != null) {
      return Container(
        height: MediaQuery.of(context).size.height/1.3,
        width: MediaQuery.of(context).size.width,
        child: Image.asset("assets/haritalar/my/${bilgiler [index]["path"]}.png",),);
    }
    else {
      return Container();
    }
  }

  Text bilgileriGetirText(int index) {

    String bilgi ="";
    String madde ="madde";

    int len = (bilgiler[index] as Map<dynamic, dynamic>).length;
    for(int i = 1; i< len-1; i++ ) {
      madde = "madde" + i.toString();
      bilgi += bilgiler [index][madde].toString();
    }

    return Text(
               bilgi, style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/35, color: Colors.grey.shade900,
                fontWeight: FontWeight.bold,
              ),);
  }

  Future<List> veriKaynaginiOkuBilgi() async {

    var gelenJson = await DefaultAssetBundle.of(context)
        .loadString('assets/data/bilgiler.json');

    List bilgiListesi = json.decode(gelenJson.toString());

    return bilgiListesi;
  }
}
