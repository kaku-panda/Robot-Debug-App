////////////////////////////////////////////////////////////////////////////////////////////
/// import
////////////////////////////////////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robo_debug_app/components/button.dart';
import 'package:robo_debug_app/components/parameter_controller.dart';
import 'package:robo_debug_app/components/snackbar.dart';
import 'package:robo_debug_app/components/style.dart';
import 'package:robo_debug_app/main.dart';
import 'package:robo_debug_app/providers/websocket_provider.dart';

// 未実装
class MotorScreen extends ConsumerStatefulWidget {
  const MotorScreen({super.key});

  @override
  ConsumerState<MotorScreen> createState() => MotorScreenState();
}

class MotorScreenState extends ConsumerState<MotorScreen> with SingleTickerProviderStateMixin{

  late TabController tabController;

  TextEditingController       speedController  = TextEditingController();
  TextEditingController       kpController     = TextEditingController();
  TextEditingController       kiController     = TextEditingController();
  TextEditingController       kdController     = TextEditingController();
  List<TextEditingController> sensorController = List.generate(8, (index) => TextEditingController());

  @override
  initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    speedController.text = ref.read(settingProvider).speed.toString();
    kpController.text = ref.read(settingProvider).kp.toString();
    kiController.text = ref.read(settingProvider).ki.toString();
    kdController.text = ref.read(settingProvider).kd.toString();
    for(int i = 0; i < 8; i++){
      sensorController[i].text = ref.read(settingProvider).sensor[i].toString();
    }
  }

  @override
  void dispose() {
    speedController.dispose();
    kpController.dispose();
    kiController.dispose();
    kdController.dispose();
    for(int i = 0; i < 8; i++){
      sensorController[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    List<Widget> tabList = const [
      Tab(text: 'Speed'),
      Tab(text: 'PID'),
      Tab(text: 'Sensor'),
    ];

    Size screenSize = MediaQuery.of(context).size;

    double speed     = ref.watch(settingProvider).speed;
    double speedMax  = ref.watch(settingProvider).speedMax;
    double speedMin  = ref.watch(settingProvider).speedMin;
    double kp        = ref.watch(settingProvider).kp;
    double kpMax     = ref.watch(settingProvider).kpMax;
    double kpMin     = ref.watch(settingProvider).kpMin;
    double ki        = ref.watch(settingProvider).ki;
    double kiMax     = ref.watch(settingProvider).kiMax;
    double kiMin     = ref.watch(settingProvider).kiMin;
    double kd        = ref.watch(settingProvider).kd;
    double kdMax     = ref.watch(settingProvider).kdMax;
    double kdMin     = ref.watch(settingProvider).kdMin;
    List<int> sensor = ref.watch(settingProvider).sensor;
    int sensorMax    = ref.watch(settingProvider).sensorMax;
    int sensorMin    = ref.watch(settingProvider).sensorMin;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Parameter Tuning', style: Styles.defaultStyle18),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextButton(
                      text: "START",
                      backgroundColor: Styles.darkBgColor,
                      enable: (ref.watch(webSocketProvider).status == ConnectionStatusType.connected) ? true : false,
                      width:  screenSize.width / 4 - 10,
                      height: 40,
                      onPressed: () {
                        ref.read(webSocketProvider.notifier).sendMessage('PID:kp:${ref.read(settingProvider).kp.toStringAsFixed(3)};');
                        ref.read(webSocketProvider.notifier).sendMessage('PID:ki:${ref.read(settingProvider).ki.toStringAsFixed(3)};');
                        ref.read(webSocketProvider.notifier).sendMessage('PID:kd:${ref.read(settingProvider).kd.toStringAsFixed(3)};');
                        ref.read(webSocketProvider.notifier).sendMessage('PID:speed:${ref.read(settingProvider).speed.toStringAsFixed(3)};');
                        for(int i = 0; i < 8; i++){
                          ref.read(webSocketProvider.notifier).sendMessage('Sensor:sensor$i:${ref.read(settingProvider).sensor[i].toStringAsFixed(3)};');
                        }
                      },
                    ),
                    CustomTextButton(
                      text: "STOP",
                      backgroundColor: Styles.darkBgColor,
                      enable: (ref.watch(webSocketProvider).status == ConnectionStatusType.connected) ? true : false,
                      width:  screenSize.width / 4 - 10,
                      height: 40,
                      onPressed: () {
                        ref.read(webSocketProvider.notifier).sendMessage("stop");
                      },
                    ),
                    CustomTextButton(
                      text: "SAVE",
                      backgroundColor: Styles.darkBgColor,
                      enable: true,
                      width:  screenSize.width / 4 - 10,
                      height: 40,
                      onPressed: () {
                      },
                    ),
                    CustomTextButton(
                      text: "LOAD",
                      backgroundColor: Styles.darkBgColor,
                      enable: true,
                      width:  screenSize.width / 4 - 10,
                      height: 40,
                      onPressed: () {
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TabBar(
                    controller: tabController,
                    indicatorColor: Styles.primaryColor,
                    labelStyle: Styles.defaultStyle15,
                    labelColor: Styles.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    tabs: tabList,
                  ),
                  SizedBox(
                    height: screenSize.height - 345,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            ParamController(
                              title: 'Speed',
                              textController: speedController, 
                              value: speed,
                              min: speedMin,
                              max: speedMax,
                              updateValue: (String type, num value){
                                updateSpeedValue(value.toDouble());
                                speedController.text = value.toString();
                              },
                              updateRange: (String type, num min, num max){
                                updateSpeedRange(min.toDouble(), max.toDouble());
                              },
                              type: 'speed'
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            ParamController(
                              title: 'Ki',
                              textController: kiController, 
                              value: ki,
                              min: kiMin,
                              max: kiMax,
                              updateValue: (String type, num value){
                                updatePidValue(type, value.toDouble());
                                kiController.text = value.toString();
                              },
                              updateRange: (String type, num min, num max){
                                updatePidRange(type, min.toDouble(), max.toDouble());
                              },
                              type: 'ki'
                            ),
                            ParamController(
                              title: 'Kp',
                              textController: kpController, 
                              value: kp,
                              min: kpMin,
                              max: kpMax,
                              updateValue: (String type, num value){
                                updatePidValue(type, value.toDouble());
                                kpController.text = value.toString();
                              },
                              updateRange: (String type, num min, num max){
                                updatePidRange(type, min.toDouble(), max.toDouble());
                              },
                              type: 'kp'
                            ),
                            ParamController(
                              title: 'Kd',
                              textController: kdController, 
                              value: kd,
                              min: kdMin,
                              max: kdMax,
                              updateValue: (String type, num value){
                                updatePidValue(type, value.toDouble());
                                kdController.text = value.toString();
                              },
                              updateRange: (String type, num min, num max){
                                updatePidRange(type, min.toDouble(), max.toDouble());
                              },
                              type: 'kd'
                            ),
                          ],
                        ),
                              
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (int i = 0; i < 8; i++)
                                    Column(
                                      children: [
                                        Text(
                                          '${7-i}',
                                          style: Styles.defaultStyle18,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: const BoxDecoration(
                                              color: Styles.primaryColor,
                                              borderRadius: BorderRadius.all(Radius.circular(2)),
                                            ),
                                            child: Center(
                                              child: Text(
                                                sensor[7-i].toString(),
                                                style: Styles.defaultStyle18,
                                              ),
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20), 
                              for (int i = 0; i < 8; i++)
                              ParamController(
                                title: 'Sensor ${7-i}',
                                textController: sensorController[7-i], 
                                value: sensor[7-i],
                                min: sensorMin,
                                max: sensorMax,
                                updateValue: (String type, num value){
                                  updateSensorValue(type, value.round());
                                  sensorController[7-i].text = value.round().toString();
                                },
                                updateRange: (String type, num min, num max){
                                  updateSensorRange(min.round(), max.round());
                                },
                                type: 'sensor${7-i}'
                              ),
                              const SizedBox(height: 20), 
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateSpeedValue(double value) {
    final status = ref.read(webSocketProvider).status;

    ref.read(settingProvider).speed = value;
    ref.read(settingProvider).storePreferences();

    if (status == ConnectionStatusType.connected) {
      final String message = 'Speed:${value.toStringAsFixed(3)};';
      ref.read(webSocketProvider.notifier).sendMessage(message);
    } else {
      showSnackBar(
        message: "WebSocket is not connected",
        type: SnackBarType.error,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void updateSpeedRange(double min, double max) {
    ref.read(settingProvider).speedMin = min;
    ref.read(settingProvider).speedMax = max;

    if (ref.read(settingProvider).speed < min) {
      ref.read(settingProvider).speed = min;
    } else if (ref.read(settingProvider).speed > max) {
      ref.read(settingProvider).speed = max;
    }

    ref.read(settingProvider).storePreferences();
  }

  void updatePidValue(String type, double value) {
    final status = ref.read(webSocketProvider).status;

    switch (type) {
      case 'kp':
        ref.read(settingProvider).kp = value;
        break;
      case 'ki':
        ref.read(settingProvider).ki = value;
        break;
      case 'kd':
        ref.read(settingProvider).kd = value;
        break;
    }
    ref.read(settingProvider).storePreferences();

    if (status == ConnectionStatusType.connected) {
      final String message = 'PID:$type:${value.toStringAsFixed(3)};';
      ref.read(webSocketProvider.notifier).sendMessage(message);
    } else {
      showSnackBar(
        message: "WebSocket is not connected",
        type: SnackBarType.error,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void updatePidRange(String type, double min, double max) {
    switch (type) {
      case 'kp':
        ref.read(settingProvider).kpMin = min;
        ref.read(settingProvider).kpMax = max;
        if (ref.read(settingProvider).kp < min) {
          ref.read(settingProvider).kp = min;
        } else if (ref.read(settingProvider).kp > max) {
          ref.read(settingProvider).kp = max;
        }
        break;
      case 'ki':
        ref.read(settingProvider).kiMin = min;
        ref.read(settingProvider).kiMax = max;
        if (ref.read(settingProvider).ki < min) {
          ref.read(settingProvider).ki = min;
        } else if (ref.read(settingProvider).ki > max) {
          ref.read(settingProvider).ki = max;
        }
        break;
      case 'kd':
        ref.read(settingProvider).kdMin = min;
        ref.read(settingProvider).kdMax = max;
        if (ref.read(settingProvider).kd < min) {
          ref.read(settingProvider).kd = min;
        } else if (ref.read(settingProvider).kd > max) {
          ref.read(settingProvider).kd = max;
        }
        break;
    }
    ref.read(settingProvider).storePreferences();
  }

  void updateSensorValue(String type, int value) {
    final status = ref.read(webSocketProvider).status;

    switch (type) {
      case 'sensor0':
        ref.read(settingProvider).sensor[0]  = value;
        break;
      case 'sensor1':
        ref.read(settingProvider).sensor[1]  = value;
        break;
      case 'sensor2':
        ref.read(settingProvider).sensor[2]  = value;
        break;
      case 'sensor3':
        ref.read(settingProvider).sensor[3]  = value;
        break;
      case 'sensor4':
        ref.read(settingProvider).sensor[4]  = value;
        break;
      case 'sensor5':
        ref.read(settingProvider).sensor[5]  = value;
        break;
      case 'sensor6':
        ref.read(settingProvider).sensor[6]  = value;
        break;
      case 'sensor7':
        ref.read(settingProvider).sensor[7]  = value;
        break;
    }
    ref.read(settingProvider).storePreferences();

    if (status == ConnectionStatusType.connected) {
      final String message = 'Sensor:$type:${value.toStringAsFixed(3)};';
      ref.read(webSocketProvider.notifier).sendMessage(message);
    } else {
      showSnackBar(
        message: "WebSocket is not connected",
        type: SnackBarType.error,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void updateSensorRange(int min, int max){

    print(ref.read(settingProvider).sensorMax);
    print(ref.read(settingProvider).sensorMin);
    
    ref.read(settingProvider).sensorMin = min;
    ref.read(settingProvider).sensorMax = max;

    print(ref.read(settingProvider).sensorMax);
    print(ref.read(settingProvider).sensorMin);

    for(int i = 0; i < 8; i++){
      if (ref.read(settingProvider).sensor[i] < min) {
        ref.read(settingProvider).sensor[i] = min;
      } else if (ref.read(settingProvider).sensor[i] > max) {
        ref.read(settingProvider).sensor[i] = max;
      }
    }

    ref.read(settingProvider).storePreferences();
    setState(() {});
  }
}
