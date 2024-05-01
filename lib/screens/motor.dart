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
  
  @override
  Widget build(BuildContext context) {


    double speed = ref.watch(settingProvider).speed;
    double kp = ref.watch(settingProvider).kp;
    double ki = ref.watch(settingProvider).ki;
    double kd = ref.watch(settingProvider).kd;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('PID Tuning', style: Styles.defaultStyle18),
      ),
      body: SafeArea(
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
                      text: "START!",
                      backgroundColor: Styles.darkBgColor,
                      enable: true,
                      width: 100,
                      height: 60,
                      onPressed: () {
                        ref.read(webSocketProvider.notifier).sendMessage('PID:kp:${ref.read(settingProvider).kp.toStringAsFixed(3)};');
                        ref.read(webSocketProvider.notifier).sendMessage('PID:ki:${ref.read(settingProvider).ki.toStringAsFixed(3)};');
                        ref.read(webSocketProvider.notifier).sendMessage('PID:kd:${ref.read(settingProvider).kd.toStringAsFixed(3)};');
                        ref.read(webSocketProvider.notifier).sendMessage('PID:speed:${ref.read(settingProvider).speed.toStringAsFixed(3)};');
                        ref.read(webSocketProvider.notifier).sendMessage("start");
                      },
                    ),
                    CustomTextButton(
                      text: "STOP!",
                      backgroundColor: Styles.darkBgColor,
                      enable: true,
                      width: 100,
                      height: 60,
                      onPressed: () {
                        ref.read(webSocketProvider.notifier).sendMessage("stop");
                      },
                    ),

                  ],
                ),
                Text(
                  'Speed: $speed',
                  style: Styles.defaultStyle18,
                ),
                Slider(
                  value: speed,
                  activeColor: Styles.primaryColor,
                  min: 0.0,
                  max: 1.0,
                  divisions: 1000,
                  label: kd.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      updatePidValue('speed', value);
                    });
                  },
                ),
                Text(
                  'Kp: $kp',
                  style: Styles.defaultStyle18,
                ),
                Slider(
                  value: kp,
                  activeColor: Styles.primaryColor,
                  min: 0.0,
                  max: 0.5,
                  divisions: 1000,
                  label: kd.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      updatePidValue('kp', value);
                    });
                  },
                ),
                Text(
                  'Ki: $ki',
                  style: Styles.defaultStyle18,
                ),
                Slider(
                  value: ki,
                  activeColor: Styles.primaryColor,
                  min: 0,
                  max: 0.01,
                  divisions: 1000,
                  label: ki.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      updatePidValue('ki', value);
                    });
                  },
                ),
                Text(
                  'Kd: $kd',
                  style: Styles.defaultStyle18,
                ),
                Slider(
                  value: kd,
                  activeColor: Styles.primaryColor,
                  min: 0,
                  max: 10,
                  divisions: 1000,
                  label: kd.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      updatePidValue('kd', value);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updatePidValue(String type, double value) {
    final status = ref.read(webSocketProvider).status;

    if (status == ConnectionStatusType.connected) {
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
      }
      ref.read(settingProvider).storePreferences();

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
