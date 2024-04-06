import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robo_debug_app/components/style.dart';
import 'package:robo_debug_app/main.dart';

const ballSize = 20.0;
const step = 5.0;

class JoystickScreen extends ConsumerStatefulWidget {
  const JoystickScreen({super.key});

  @override
  ConsumerState<JoystickScreen> createState() => JoystickScreenState();
}

class JoystickScreenState extends ConsumerState<JoystickScreen> with SingleTickerProviderStateMixin {
  
  double _x = 100;
  double _y = 100;

  JoystickMode _joystickMode = JoystickMode.all;

  AnimationController? _controller;
  Animation<double>? _animationX;
  Animation<double>? _animationY;

  int leftMotorAccel          = 0;
  int rightMotorAccel         = 0;
  String leftMotorAccelForward   = "00";
  String rightMotorAccelForward  = "00";
  String leftMotorAccelBackward  = "00";
  String rightMotorAccelBackward = "00";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Joystick'),
        actions: [
          JoystickModeDropdown(
            mode: _joystickMode,
            onChanged: (JoystickMode value) {
              setState(() {
                _joystickMode = value;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Styles.darkBgColor,
            ),
            // Ball(_x, _y),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: MotorSpeedDisplay(leftMotorSpeed: leftMotorAccel, rightMotorSpeed: rightMotorAccel),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.8),
              child: Joystick(
                mode: _joystickMode,
                listener: (details) {
                  final newX = _x + step * details.x;
                  final newY = _y + step * details.y;

                  leftMotorAccel  = (-details.y*255 + details.x*255).clamp(-255, 255).toInt();
                  rightMotorAccel = (-details.y*255 - details.x*255).clamp(-255, 255).toInt();
                  
                  leftMotorAccelForward   = ((leftMotorAccel  <= 0) ? 0 : (leftMotorAccel   & 0xFF)).toRadixString(16).padLeft(2, "0");
                  rightMotorAccelForward  = ((rightMotorAccel <= 0) ? 0 : (rightMotorAccel  & 0xFF)).toRadixString(16).padLeft(2, "0");
                  leftMotorAccelBackward  = ((leftMotorAccel  >= 0) ? 0 : (-leftMotorAccel  & 0xFF)).toRadixString(16).padLeft(2, "0");
                  rightMotorAccelBackward = ((rightMotorAccel >= 0) ? 0 : (-rightMotorAccel & 0xFF)).toRadixString(16).padLeft(2, "0");

                  String message = "accel $leftMotorAccelForward$rightMotorAccelForward$leftMotorAccelBackward$rightMotorAccelBackward";
                  ref.read(webSocketProvider.notifier).sendMessage(message);

                  _animationX = Tween<double>(begin: _x, end: newX).animate(_controller!)
                    ..addListener(() {
                      setState(() {
                        _x = _animationX!.value;
                      });
                    });
                  _animationY = Tween<double>(begin: _y, end: newY).animate(_controller!)
                    ..addListener(() {
                      setState(() {
                        _y = _animationY!.value;
                      });
                    });
                  _controller!.forward(from: 0.0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JoystickModeDropdown extends StatelessWidget {
  final JoystickMode mode;
  final ValueChanged<JoystickMode> onChanged;

  const JoystickModeDropdown(
      {super.key, required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: FittedBox(
          child: DropdownButton(
            value: mode,
            onChanged: (v) {
              onChanged(v as JoystickMode);
            },
            items: const [
              DropdownMenuItem(
                value: JoystickMode.all,
                child: Text('All Directions')
              ),
              DropdownMenuItem(
                value: JoystickMode.horizontalAndVertical,
                child: Text('Vertical And Horizontal'),
              ),
              DropdownMenuItem(
                value: JoystickMode.horizontal,
                child: Text('Horizontal'),
              ),
              DropdownMenuItem(
                value: JoystickMode.vertical,
                child: Text('Vertical'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Ball extends StatelessWidget {
  final double x;
  final double y;

  const Ball(this.x, this.y, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: ballSize,
        height: ballSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Styles.primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3),
            )
          ],
        ),
      ),
    );
  }
}

class MotorSpeedDisplay extends StatelessWidget {
  final int leftMotorSpeed;
  final int rightMotorSpeed;

  const MotorSpeedDisplay({
    super.key,
    required this.leftMotorSpeed,
    required this.rightMotorSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMotorSpeedLabel('Left:', Colors.orangeAccent),
        _buildMotorSpeedValue(leftMotorSpeed, Colors.orangeAccent),
        const SizedBox(width: 20),
        _buildMotorSpeedLabel('Right:', Colors.blueAccent),
        _buildMotorSpeedValue(rightMotorSpeed, Colors.blueAccent),
      ],
    );
  }

  Widget _buildMotorSpeedLabel(String label, Color color) {
    return SizedBox(
      width: 50,
      child: Text(
        label,
        style: Styles.defaultStyle18.copyWith(color: color),
      ),
    );
  }

  Widget _buildMotorSpeedValue(int speed, Color color) {
    return SizedBox(
      width: 50,
      child: Text(
        '$speed',
        textAlign: TextAlign.right,
        style: Styles.defaultStyle18.copyWith(color: color),
      ),
    );
  }
}
