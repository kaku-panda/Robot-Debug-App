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

  double _kp = 0;
  double _ki = 0;
  double _kd = 0;

  String get webSocketAddress => _webSocketAddress;

  bool get enableDarkTheme => _enableDarkTheme;
  bool get defaultShiftView => _defaultShiftView;
  
  double get screenPaddingTop => _screenPaddngTop;
  double get screenPaddingBottom => _screenPaddngBottom;
  double get appBarHeight => _appBarHeight;
  double get navigationBarHeight => _navigationBarHeight;

  double get kp => _kp;
  double get ki => _ki;
  double get kd => _kd;

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

  set kp(double kp) {
    _kp = kp;
    notifyListeners();
  }

  set ki(double ki){
    _ki = ki;
    notifyListeners();
  }

  set kd(double kd) {
    _kd = kd;
    notifyListeners();
  } 

  Future loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _enableDarkTheme = prefs.getBool('enableDarkTheme') ?? true;
    _defaultShiftView = prefs.getBool('defaultShiftView') ?? false;
    
    _webSocketAddress = prefs.getString('webSocketAddress') ?? '192.169.1.42:8081';

    _kp = prefs.getDouble('kp') ?? 0;
    _ki = prefs.getDouble('ki') ?? 0;
    _kd = prefs.getDouble('kd') ?? 0;
    notifyListeners();
  }

  Future storePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('enableDarkTheme', _enableDarkTheme);
    prefs.setBool('defaultShiftView', _defaultShiftView);
    prefs.setString('webSocketAddress', _webSocketAddress);
    prefs.setDouble('kp', _kp);
    prefs.setDouble('ki', _ki);
    prefs.setDouble('kd', _kd);
    notifyListeners();
  }
}
