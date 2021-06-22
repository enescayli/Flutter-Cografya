import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HaritaTamSayfa extends StatelessWidget {

  final String resim;

  HaritaTamSayfa({this.resim});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
      body: InteractiveViewer(
        minScale: 1,
        maxScale: 3,

        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            resim,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
