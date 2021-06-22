import 'package:cografya_flut_2_0/alistirma.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'harita_getir.dart';
import 'haritalar_sayfasi.dart';
import 'konu_anlatimi.dart';
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HaritaGetir>(
          create: (context) => HaritaGetir("assets/btn_img/turkeyd.png", false),
        ),
      ],
      child: MaterialApp(
        title: 'Coğrafya',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AnaSayfa(),
      ),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.teal.shade900,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HaritalarSayfasi()));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height * (0.16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Haritalar",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 3.0),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            Expanded(
                                child: Image.asset(
                                  "assets/btn_img/turkey.png",
                                )),
                          ],
                        )),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red.shade900,
                      onPrimary: Colors.pink.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlistirmaSayfasi()));
                    },

                    child: Container(
                        height: MediaQuery.of(context).size.height * (0.16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Alıştırma Yap",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 3.0),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            Expanded(
                                child: Image.asset(
                                  "assets/btn_img/que.png",
                                )),
                          ],
                        )),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red.shade900,
                      onPrimary: Colors.pink.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KonuAnlatimi()));
                    },

                    child: Container(
                        height: MediaQuery.of(context).size.height * (0.16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Konu Anlatımı",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 3.0),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            Expanded(
                                child: Image.asset(
                                  "assets/alistirma/Ovalar/Ergene.png",
                                )),
                          ],
                        )),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red.shade900,
                      onPrimary: Colors.pink.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            customLaunch(
                                'mailto:2020cdggames@gmail.com?subject=Öneri%20&%20İstek&body='
                            );
                          },
                          icon: Icon(Icons.mail_outline, size: MediaQuery.of(context).size.width/22, color: Colors.white,),),
                        Text("İstek ve Önerileriniz için bize ulaşbilirsiniz", style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width/50,
                          fontStyle: FontStyle.italic,
                        ),)
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void customLaunch(command) async{
    if(await canLaunch(command)){
      await launch(command);
    }
    else print("Hata");
  }
}
