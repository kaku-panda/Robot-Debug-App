////////////////////////////////////////////////////////////////////////////////////////////
/// import
////////////////////////////////////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier {
  String _webSocketAddress = '192.168.1.42:8081';
  bool _enableDarkTheme = true;
  bool _defaultShiftView = false;
  bool isEditting = false;
  bool isRotating = false;
  double _screenPaddngTop = 0.0;
  double _screenPaddngBottom = 0.0;
  double _appBarHeight = 0.0;
  double _navigationBarHeight = 0.0;

  String get webSocketAddress => _webSocketAddress;
  bool get enableDarkTheme => _enableDarkTheme;
  bool get defaultShiftView => _defaultShiftView;
  double get screenPaddingTop => _screenPaddngTop;
  double get screenPaddingBottom => _screenPaddngBottom;
  double get appBarHeight => _appBarHeight;
  double get navigationBarHeight => _navigationBarHeight;

  set webSocketAddress(String result) {
    _webSocketAddress = result;
    notifyListeners();
  }

  set enableDarkTheme(bool result) {
    _enableDarkTheme = result;
    notifyListeners();
  }

  set defaultShiftView(bool result) {
    _defaultShiftView = result;
    notifyListeners();
  }

  set screenPaddingTop(double paddingTop) {
    _screenPaddngTop = paddingTop;
    notifyListeners();
  }

  set screenPaddingBottom(double paddingBottom) {
    _screenPaddngBottom = paddingBottom;
    notifyListeners();
  }

  set appBarHeight(double appBarHeight){
    _appBarHeight = appBarHeight;
    notifyListeners();
  }

  set navigationBarHeight(double navigationBarHeight) {
    _navigationBarHeight = navigationBarHeight;
    notifyListeners();
  }

  Future loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _enableDarkTheme = prefs.getBool('enableDarkTheme') ?? true;
    _defaultShiftView = prefs.getBool('defaultShiftView') ?? false;
    _webSocketAddress = prefs.getString('webSocketAddress') ?? '192.169.1.42:8081';
    notifyListeners();
  }

  Future storePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('enableDarkTheme', _enableDarkTheme);
    prefs.setBool('defaultShiftView', _defaultShiftView);
    prefs.setString('webSocketAddress', _webSocketAddress);
    notifyListeners();
  }
}
