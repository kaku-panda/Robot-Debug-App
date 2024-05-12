import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robo_debug_app/components/snackbar.dart';
import 'package:robo_debug_app/components/modal_window.dart';
import 'package:robo_debug_app/components/button.dart';
import 'package:robo_debug_app/components/style.dart';

class ParamController extends ConsumerWidget {
  final String title;
  final TextEditingController textController;
  final num value;
  final num min;
  final num max;
  final Function updateValue;
  final Function updateRange;
  final String type;

  const ParamController({
    super.key,
    required this.title,
    required this.textController,
    required this.value,
    required this.min,
    required this.max,
    required this.type,
    required this.updateValue,
    required this.updateRange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double parsedValue = value.toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                    onSubmitted: (String value){
                      try {
                        double parsedValue = double.parse(value);
                        if (parsedValue < max && parsedValue > min) {
                          updateValue(type, parsedValue);
                        } else {
                          showSnackBar(
                            message: "Please enter a value between $min and $max",
                            type: SnackBarType.error,
                            duration: const Duration(seconds: 2),
                          );
                          textController.text = this.value.toString();
                        }
                      } catch (e) {
                        showSnackBar(
                          message: "Please enter a valid number",
                          type: SnackBarType.error,
                          duration: const Duration(seconds: 2),
                        );
                        textController.text = this.value.toString();
                      }
                    }, 
                  ),
                ),
                TextButton(
                  onPressed: (){
                    TextEditingController minController = TextEditingController(text: "$min");
                    TextEditingController maxController = TextEditingController(text: "$max");
                    
                    showCustomModalWindow(
                      context,
                      0.5,
                      Center(
                        child: Column(
                          children: [
                            Text('Edit Range', style: Styles.defaultStyle20),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                              child: Row(
                                children: [
                                  Text('Minumum Value : ', style: Styles.defaultStyle18),
                                  Expanded(
                                    child: TextField(
                                      controller: minController,
                                      decoration: InputDecoration(
                                        labelStyle: Styles.defaultStyle18,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                              child: Row(
                                children: [
                                  Text('Maximum Value : ', style: Styles.defaultStyle18),
                                  Expanded(
                                    child: TextField(
                                      controller: maxController,
                                      decoration: InputDecoration(
                                        labelStyle: Styles.defaultStyle18,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomTextButton(
                              text: 'Save',
                              backgroundColor: Styles.darkBgColor,
                              enable: true,
                              width: 100,
                              height: 40,
                              onPressed: (){
                                try {
                                  double newMin = double.parse(minController.text);
                                  double newMax = double.parse(maxController.text);
                                  if (newMin >= newMax) {
                                    showSnackBar(
                                      message: "Minimum value must be less than maximum value",
                                      type: SnackBarType.error,
                                      duration: const Duration(seconds: 2),
                                    );
                                    return;
                                  }
                                  updateRange(type, newMin, newMax);
                                } catch (e) {
                                  showSnackBar(
                                    message: "Please enter a valid number",
                                    type: SnackBarType.error,
                                    duration: const Duration(seconds: 2),
                                  );
                                }
                              },
                            ),
                          ]
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Edit Range',
                    style: Styles.headlineStyleBlue13,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Slider(
            value: parsedValue,
            activeColor: Styles.primaryColor,
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: 1000,
            label: value.toString(),
            onChanged: (double newValue) {
              updateValue(type, newValue);
            },
          ),
        ],
      ),
    );
  }
}
