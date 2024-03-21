////////////////////////////////////////////////////////////////////////////////////////////
/// import
////////////////////////////////////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robo_debug_app/components/style.dart';
import 'package:robo_debug_app/main.dart';

// 未実装
class MotorScreen extends ConsumerStatefulWidget {
  const MotorScreen({super.key});

  @override
  ConsumerState<MotorScreen> createState() => MotorScreenState();
}

class MotorScreenState extends ConsumerState<MotorScreen> {
  
  @override
  Widget build(BuildContext context) {


  double kp = ref.watch(settingProvider).kp;
  double ki = ref.watch(settingProvider).ki;
  double kd = ref.watch(settingProvider).kd;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Kp: ${kp.round()}',
                        style: Styles.defaultStyle18,
                      ),
                      Slider(
                        value: kp,
                        activeColor: Styles.primaryColor,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: kd.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            ref.read(settingProvider).kp = value;
                            ref.read(settingProvider).storePreferences();
                          });
                        },
                      ),
                      Text(
                        'Ki: ${ki.round()}',
                        style: Styles.defaultStyle18,
                      ),
                      Slider(
                        value: ki,
                        activeColor: Styles.primaryColor,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: ki.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            ref.read(settingProvider).ki = value;
                            ref.read(settingProvider).storePreferences();
                          });
                        },
                      ),
                      Text(
                        'Kd: ${kd.round()}',
                        style: Styles.defaultStyle18,
                      ),
                      Slider(
                        value: kd,
                        activeColor: Styles.primaryColor,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: kd.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            ref.read(settingProvider).kd = value;
                            ref.read(settingProvider).storePreferences();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
