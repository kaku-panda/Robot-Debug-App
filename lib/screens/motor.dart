////////////////////////////////////////////////////////////////////////////////////////////
/// import
////////////////////////////////////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robo_debug_app/components/button.dart';
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

class MotorScreenState extends ConsumerState<MotorScreen> {

  TextEditingController speedController    = TextEditingController();
  TextEditingController kpController       = TextEditingController();
  TextEditingController kiController       = TextEditingController();
  TextEditingController kdController       = TextEditingController();
  TextEditingController sensor34Controller = TextEditingController();
  TextEditingController sensor52Controller = TextEditingController();
  TextEditingController sensor61Controller = TextEditingController();
  TextEditingController sensor70Controller = TextEditingController();

  @override
  initState() {
    super.initState();
    speedController.text = ref.read(settingProvider).speed.toString();
    kpController.text = ref.read(settingProvider).kp.toString();
    kiController.text = ref.read(settingProvider).ki.toString();
    kdController.text = ref.read(settingProvider).kd.toString();
  }

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    double speed    = ref.watch(settingProvider).speed;
    double kp       = ref.watch(settingProvider).kp;
    double ki       = ref.watch(settingProvider).ki;
    double kd       = ref.watch(settingProvider).kd;
    double sensor43 = ref.watch(settingProvider).sensor43;
    double sensor52 = ref.watch(settingProvider).sensor52;
    double sensor61 = ref.watch(settingProvider).sensor61;
    double sensor70 = ref.watch(settingProvider).sensor70;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('PID Tuning', style: Styles.defaultStyle18),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
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
                          ref.read(webSocketProvider.notifier).sendMessage('PID:sensor43:${ref.read(settingProvider).sensor43.toStringAsFixed(3)};');
                          ref.read(webSocketProvider.notifier).sendMessage('PID:sensor52:${ref.read(settingProvider).sensor52.toStringAsFixed(3)};');
                          ref.read(webSocketProvider.notifier).sendMessage('PID:sensor61:${ref.read(settingProvider).sensor61.toStringAsFixed(3)};');
                          ref.read(webSocketProvider.notifier).sendMessage('PID:sensor70:${ref.read(settingProvider).sensor70.toStringAsFixed(3)};');
                          ref.read(webSocketProvider.notifier).sendMessage("start");
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

                  const SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Text(
                      'Speed',
                      style: Styles.defaultStyle20,
                    ),
                  ),

                  paramController('Speed', speedController, speed, 0, 1, 'speed'),

                  const Divider(
                    color: Styles.hiddenColor,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Text(
                      'PID',
                      style: Styles.defaultStyle20,
                    ),
                  ),

                  paramController('Kp', kpController, kp, 0, 1, 'kp'),
                  paramController('Ki', kiController, ki, 0, 1, 'ki'),
                  paramController('Kd', kdController, kd, 0, 10, 'kd'),

                  const Divider(
                    color: Styles.hiddenColor,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Text(
                      'Sensor',
                      style: Styles.defaultStyle20,
                    ),
                  ),
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
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  paramController('sensor 7.0', sensor70Controller, sensor70, 0, 1, 'sensor70'),
                  paramController('sensor 6-1', sensor61Controller, sensor61, 0, 1, 'sensor61'),
                  paramController('sensor 5-2', sensor52Controller, sensor52, 0, 1, 'sensor52'),
                  paramController('sensor 4-3', sensor34Controller, sensor43, 0, 1, 'sensor43'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget paramController(String title, TextEditingController textController, double value, double min, double max, String type) {
    
    if(value < min) value = min;
    if(value > max) value = max;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    '$title =',
                    style: Styles.defaultStyle18,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    textInputAction: TextInputAction.done,  
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      isCollapsed: true,
                      labelStyle: Styles.defaultStyle18,
                    ),
                    onSubmitted: (String value) {
                      try {
                        double parsedValue = double.parse(value);
                        if (parsedValue < max && parsedValue > min) {
                          updatePidValue(type, parsedValue);
                          textController.text = value;
                        } else {
                          showSnackBar(
                            message: "Please enter a value between $min and $max",
                            type: SnackBarType.error,
                            duration: const Duration(seconds: 2),
                          );
                        }
                      } catch (e) {
                        showSnackBar(
                          message: "Please enter a valid number",
                          type: SnackBarType.error,
                          duration: const Duration(seconds: 2),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Slider(
            value: value,
            activeColor: Styles.primaryColor,
            min: min,
            max: max,
            divisions: 1000,
            label: value.toString(),
            onChanged: (double value) {
              setState(() {
                updatePidValue(type, value);
                textController.text = '$value';
              });
            },
          ),
        ],
      ),
    );
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
      case 'speed':
        ref.read(settingProvider).speed = value;
        break;
      case 'sensor43':
        ref.read(settingProvider).sensor43 = value;
        break;
      case 'sensor52':
        ref.read(settingProvider).sensor52 = value;
        break;
      case 'sensor61':  
        ref.read(settingProvider).sensor61 = value;
        break;
      case 'sensor70':    
        ref.read(settingProvider).sensor70 = value;
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
}
