////////////////////////////////////////////////////////////////////////////////////////////
/// import
////////////////////////////////////////////////////////////////////////////////////////////
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robo_debug_app/components/style.dart';

// my package
import 'package:robo_debug_app/main.dart';

////////////////////////////////////////////////////////////////////////////////////////////
/// Home 画面
////////////////////////////////////////////////////////////////////////////////////////////

class ConsoleScreen extends ConsumerStatefulWidget {
  const ConsoleScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<ConsoleScreen> with SingleTickerProviderStateMixin {
  bool isOwner = false;
  double appBarHeight = 0;
  Size screenSize = const Size(0, 0);
  List<String> logs  = [];

  // TextField の動作をスムーズにするための変数
  final FocusNode focusNode = FocusNode();
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

        // 画面サイズの取得
    appBarHeight = ref.read(settingProvider).appBarHeight + ref.read(settingProvider).screenPaddingTop;
    screenSize = Size(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height -
          ref.watch(settingProvider).appBarHeight -
          ref.watch(settingProvider).navigationBarHeight -
          ref.watch(settingProvider).screenPaddingTop -
          ref.watch(settingProvider).screenPaddingBottom,
    );

    Color bgColor = Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Console", style: Styles.defaultStyle20),
                Expanded(
                  child: ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) => Text(logs[index]),
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.1,
                  child: TextField(
                    controller: textController,
                    cursorColor: Styles.primaryColor,
                    style: Styles.defaultStyleGreen13,
                    focusNode: focusNode,
                    autofocus: false,
                    decoration: InputDecoration(
                      fillColor: bgColor,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      prefixIconColor: Styles.primaryColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(
                          color: Styles.hiddenColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(
                          color: Styles.primaryColor,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.navigate_next),
                      hintText: 'type command here',
                      hintStyle: Styles.defaultStyle15,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    onTap: () {
                      FocusScope.of(context).requestFocus(focusNode);
                    },
                    onChanged: (value) {
                      // onTextChanged(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}