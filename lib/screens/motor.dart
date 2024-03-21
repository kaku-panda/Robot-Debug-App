////////////////////////////////////////////////////////////////////////////////////////////
/// import
////////////////////////////////////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:robo_debug_app/components/style.dart';

// 未実装
class MotorScreen extends StatelessWidget {
  const MotorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();

    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: const Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Text(
                      "Motor",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
