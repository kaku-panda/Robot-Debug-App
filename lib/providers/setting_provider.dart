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

  double    _speed     = 0;
  double    _speedMax  = 1;
  double    _speedMin  = 0;
  double    _kp        = 0;
  double    _kpMax     = 1;
  double    _kpMin     = 0;
  double    _ki        = 0;
  double    _kiMax     = 1;
  double    _kiMin     = 0;
  double    _kd        = 0;
  double    _kdMax     = 1;
  double    _kdMin     = 0;
  List<int> _sensor    = [0,0,0,0,0,0,0,0];
  int       _sensorMax = 1;
  int       _sensorMin = 0;

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
  List<int> get sensor => _sensor;
  int get sensorMax    => _sensorMax;
  int get sensorMin    => _sensorMin;

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

  set sensor(List<int> sensor) {
    _sensor = sensor;
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

    _speed     = prefs.getDouble('speed') ?? 0;
    _speedMax  = prefs.getDouble('speedMax') ?? 1;
    _speedMin  = prefs.getDouble('speedMin') ?? 0;
    _kp        = prefs.getDouble('kp') ?? 0;
    _kpMax     = prefs.getDouble('kpMax') ?? 1;
    _kpMin     = prefs.getDouble('kpMin') ?? 0;
    _ki        = prefs.getDouble('ki') ?? 0;
    _kiMax     = prefs.getDouble('kiMax') ?? 1;
    _kiMin     = prefs.getDouble('kiMin') ?? 0;
    _kd        = prefs.getDouble('kd') ?? 0;
    _kdMax     = prefs.getDouble('kdMax') ?? 1;
    _kdMin     = prefs.getDouble('kdMin') ?? 0;
    _sensor[0] = prefs.getInt('sensor0') ?? 0;
    _sensor[1] = prefs.getInt('sensor1') ?? 0;
    _sensor[2] = prefs.getInt('sensor2') ?? 0;
    _sensor[3] = prefs.getInt('sensor3') ?? 0;
    _sensor[4] = prefs.getInt('sensor4') ?? 0;
    _sensor[5] = prefs.getInt('sensor5') ?? 0;
    _sensor[6] = prefs.getInt('sensor6') ?? 0;
    _sensor[7] = prefs.getInt('sensor7') ?? 0;
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
    prefs.setDouble('kpMax', _kpMax);
    prefs.setDouble('kpMin', _kpMin);
    prefs.setDouble('ki', _ki);
    prefs.setDouble('kiMax', _kiMax);
    prefs.setDouble('kiMin', _kiMin);
    prefs.setDouble('kd', _kd);
    prefs.setDouble('kdMax', _kdMax);
    prefs.setDouble('kdMin', _kdMin);
    prefs.setInt('sensor0',_sensor[0]);
    prefs.setInt('sensor1',_sensor[1]);
    prefs.setInt('sensor2',_sensor[2]);
    prefs.setInt('sensor3',_sensor[3]);
    prefs.setInt('sensor4',_sensor[4]);
    prefs.setInt('sensor5',_sensor[5]);
    prefs.setInt('sensor6',_sensor[6]);
    prefs.setInt('sensor7',_sensor[7]);
    prefs.setInt('sensorMax',_sensorMax);
    prefs.setInt('sensorMin',_sensorMin);
    notifyListeners();
  }
}
