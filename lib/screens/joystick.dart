import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robo_debug_app/components/style.dart';
import 'package:robo_debug_app/main.dart';

const ballSize = 20.0;
const step = 40.0;

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
            Ball(_x, _y),
            Align(
              alignment: const Alignment(0, 0.8),
              child: Joystick(
                mode: _joystickMode,
                listener: (details) {
                  final newX = _x + step * details.x;
                  final newY = _y + step * details.y;

                  int leftMotorSpeed  = (-details.y*100 + details.x*100).clamp(-100, 100).toInt();
                  int rightMotorSpeed = (-details.y*100 - details.x*100).clamp(-100, 100).toInt();
                  
                  String message = "accel ${((leftMotorSpeed & 0xFF) << 8) | (rightMotorSpeed & 0xFF)}";
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
                  value: JoystickMode.all, child: Text('All Directions')),
              DropdownMenuItem(
                  value: JoystickMode.horizontalAndVertical,
                  child: Text('Vertical And Horizontal')),
              DropdownMenuItem(
                  value: JoystickMode.horizontal, child: Text('Horizontal')),
              DropdownMenuItem(
                  value: JoystickMode.vertical, child: Text('Vertical')),
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