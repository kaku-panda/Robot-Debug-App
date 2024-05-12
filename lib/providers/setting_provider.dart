////////////////////////////////////////////////////////////////////////////////////////////
/// import
////////////////////////////////////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier {
  
  String _webSocketAddress = '192.168.42.1:8081';
  bool _enableDarkTheme    = true;
  bool _defaultShiftView   = false;
  
  bool isEditting = false;
  bool isRotating = false;
  
  double _screenPaddngTop     = 0.0;
  double _screenPaddngBottom  = 0.0;
  double _appBarHeight        = 0.0;
  double _navigationBarHeight = 0.0;

  double _speed     = 0;
  double _speedMax  = 1;
  double _speedMin  = 0;
  double _kp        = 0;
  double _kpMax     = 1;
  double _kpMin     = 0;
  double _ki        = 0;
  double _kiMax     = 1;
  double _kiMin     = 0;
  double _kd        = 0;
  double _kdMax     = 1;
  double _kdMin     = 0;
  int    _sensor43  = 0;
  int    _sensor52  = 0;
  int    _sensor61  = 0;
  int    _sensor70  = 0;
  int    _sensorMax = 1;
  int    _sensorMin = 0;

  String get webSocketAddress => _webSocketAddress;
  bool get enableDarkTheme    => _enableDarkTheme;
  bool get defaultShiftView   => _defaultShiftView;
  
  double get screenPaddingTop    => _screenPaddngTop;
  double get screenPaddingBottom => _screenPaddngBottom;
  double get appBarHeight        => _appBarHeight;
  double get navigationBarHeight => _navigationBarHeight;

  double get speed     => _speed;
  double get speedMax  => _speedMax;
  double get speedMin  => _speedMin;
  double get kp        => _kp;
  double get kpMax     => _kpMax;
  double get kpMin     => _kpMin;
  double get ki        => _ki;
  double get kiMax     => _kiMax;
  double get kiMin     => _kiMin;
  double get kd        => _kd;
  double get kdMax     => _kdMax;
  double get kdMin     => _kdMin;
  int    get sensor43  => _sensor43;
  int    get sensor52  => _sensor52;
  int    get sensor61  => _sensor61;
  int    get sensor70  => _sensor70;
  int    get sensorMax => _sensorMax;
  int    get sensorMin => _sensorMin;



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

  set speed(double speed) {
    _speed = speed;
    notifyListeners();
  }

  set speedMax(double speedMax) {
    _speedMax = speedMax;
    notifyListeners();
  }

  set speedMin(double speedMin) {
    _speedMin = speedMin;
    notifyListeners();
  }

  set kp(double kp) {
    _kp = kp;
    notifyListeners();
  }

  set kpMax(double kpMax) {
    _kpMax = kpMax;
    notifyListeners();
  }

  set kpMin(double kpMin) {
    _kpMin = kpMin;
    notifyListeners();
  }

  set ki(double ki) {
    _ki = ki;
    notifyListeners();
  }

  set kiMax(double kiMax) {
    _kiMax = kiMax;
    notifyListeners();
  }

  set kiMin(double kiMin) {
    _kiMin = kiMin;
    notifyListeners();
  }

  set kd(double kd) {
    _kd = kd;
    notifyListeners();
  }

  set kdMax(double kdMax) {
    _kdMax = kdMax;
    notifyListeners();
  }

  set kdMin(double kdMin) {
    _kdMin = kdMin;
    notifyListeners();
  }

  set sensor43(int sensor43) {
    _sensor43 = sensor43;
    notifyListeners();
  }

  set sensor52(int sensor52) {
    _sensor52 = sensor52;
    notifyListeners();
  }

  set sensor61(int sensor61) {
    _sensor61 = sensor61;
    notifyListeners();
  }

  set sensor70(int sensor70) {
    _sensor70 = sensor70;
    notifyListeners();
  }

  set sensorMax(int sensorMax) {
    _sensorMax = sensorMax;
    notifyListeners();
  }

  set sensorMin(int sensorMin) {
    _sensorMin = sensorMin;
    notifyListeners();
  }

  Future loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _enableDarkTheme = prefs.getBool('enableDarkTheme') ?? true;
    _defaultShiftView = prefs.getBool('defaultShiftView') ?? false;
    
    _webSocketAddress = prefs.getString('webSocketAddress') ?? '192.169.42.1:8081';

    _speed = prefs.getDouble('speed') ?? 0;
    _speedMax = prefs.getDouble('speedMax') ?? 1;
    _speedMin = prefs.getDouble('speedMin') ?? 0;
    _kp = prefs.getDouble('kp') ?? 0;
    _kpMax = prefs.getDouble('kpMax') ?? 1;
    _kpMin = prefs.getDouble('kpMin') ?? 0;
    _ki = prefs.getDouble('ki') ?? 0;
    _kiMax = prefs.getDouble('kiMax') ?? 1;
    _kiMin = prefs.getDouble('kiMin') ?? 0;
    _kd = prefs.getDouble('kd') ?? 0;
    _kdMax = prefs.getDouble('kdMax') ?? 1;
    _kdMin = prefs.getDouble('kdMin') ?? 0;
    _sensor43 = prefs.getInt('sensor43') ?? 0;
    _sensor52 = prefs.getInt('sensor52') ?? 0;
    _sensor61 = prefs.getInt('sensor61') ?? 0;
    _sensor70 = prefs.getInt('sensor70') ?? 0;
    _sensorMax = prefs.getInt('sensorMax') ?? 1;
    _sensorMin = prefs.getInt('sensorMin') ?? 0;
    notifyListeners();
  }

  Future storePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('enableDarkTheme', _enableDarkTheme);
    prefs.setBool('defaultShiftView', _defaultShiftView);
    prefs.setString('webSocketAddress', _webSocketAddress);
    prefs.setDouble('speed', _speed);
    prefs.setDouble('speedMax', _speedMax);
    prefs.setDouble('speedMin', _speedMin);
    prefs.setDouble('kp', _kp);
    prefs.setDouble('kpMax', _kiMax);
    prefs.setDouble('kpMin', _kpMin);
    prefs.setDouble('ki', _ki);
    prefs.setDouble('kiMax', _kiMax);
    prefs.setDouble('kiMin', _kiMin);
    prefs.setDouble('kd', _kd);
    prefs.setDouble('kdMax', _kdMax);
    prefs.setDouble('kdMin', _kdMin);
    prefs.setInt('sensor43', _sensor43);
    prefs.setInt('sensor52', _sensor52);
    prefs.setInt('sensor61', _sensor61);
    prefs.setInt('sensor70', _sensor70);
    prefs.setInt('sensorMax', _sensorMax);
    prefs.setInt('sensorMin', _sensorMin);
    notifyListeners();
  }
}
