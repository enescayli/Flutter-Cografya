import 'package:flutter/material.dart';

class HaritaGetir  with ChangeNotifier {

  String _resimKaynagi;
  bool _sinir;

  HaritaGetir(this._resimKaynagi,this._sinir);
  // ignore: unnecessary_getters_setters
  String get resimKaynagi => _resimKaynagi;
  // ignore: unnecessary_getters_setters
  bool get sinir => _sinir;


  // ignore: unnecessary_getters_setters
  set resimKaynagi(String value) {
    _resimKaynagi = value;
  }
  // ignore: unnecessary_getters_setters
  set sinir(bool value) {
    _sinir = value;
  }


  void resimGuncelle(String resim) {
    _resimKaynagi = resim;
    Image.asset(resim);
    notifyListeners();
  }

  void sinirGosterGizle(bool sinirDurum) {
    _sinir = !sinirDurum;
    notifyListeners();
  }


}

