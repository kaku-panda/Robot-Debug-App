////////////////////////////////////////////////////////////////////////////////////////////
/// import
////////////////////////////////////////////////////////////////////////////////////////////
library;
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:robo_debug_app/providers/websocket_provider.dart';
import 'package:robo_debug_app/components/style.dart';
import 'package:robo_debug_app/database/console_log.dart';

// my package
import 'package:robo_debug_app/main.dart';
import 'package:robo_debug_app/database/database_helper.dart';

////////////////////////////////////////////////////////////////////////////////////////////
/// Home 画面
////////////////////////////////////////////////////////////////////////////////////////////

class ConsoleScreen extends ConsumerStatefulWidget {
  const ConsoleScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<ConsoleScreen> with SingleTickerProviderStateMixin {
  
  double appBarHeight = 0;
  Size screenSize = const Size(0, 0);

  // for web socket
  List<String> messages = [];

  // TextField の動作をスムーズにするための変数
  final FocusNode focusNode = FocusNode();
  late TextEditingController textController;

  // ssid 監視用
  String? ssid = '';
  final NetworkInfo networkInfo = NetworkInfo();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  // ログデータベース用
  late List<ConsoleLog> logs;
  DatabaseHelper dbHelper = DatabaseHelper();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    initConnectivity();
    connectivitySubscription = Connectivity().onConnectivityChanged.listen(updateConnectionStatus);
    logs = [];
    fetchConsoleLog().then((_) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => scrollToBottom()
      );
    });
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    scrollController.dispose();
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

    final connectionStatus = ref.watch(webSocketProvider).status;

    IconData      iconData;
    VoidCallback? onPressed;

    switch (connectionStatus) {
      case ConnectionStatusType.connected:
        iconData = Icons.link_off;
        onPressed = () {
          ref.read(webSocketProvider).disconnect();
        };
        break;
      case ConnectionStatusType.connecting:
        iconData = Icons.cancel;
        onPressed = () {
          ref.read(webSocketProvider).cannceled();
        };
        break;
      case ConnectionStatusType.disconnected:
      default:
        iconData = Icons.connect_without_contact;
        onPressed = () {
          final url = 'ws://${ref.read(settingProvider).webSocketAddress}';
          ref.read(webSocketProvider).connect(url);
        };
        break;
    }

    Color bgColor = Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
        title: Text('Wi-Fi : ${ssid ?? 'Unknown SSID'}', style: Styles.defaultStyle20),
        actions: [
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(iconData, size: 30),
            ),
            onPressed: onPressed,
          )
        ],
      ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: logs.length,
                itemBuilder: (context, index){
                  return logs[index].fromRobot ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${logs[index].content} ', style: logs[index].isError ? Styles.defaultStyleRed13 : Styles.defaultStyleGreen13),
                      Text('[${DateFormat('MM/dd/hh:mm:ss').format(logs[index].dateTime)}] <', style: Styles.defaultStyleGrey13, softWrap: true,),
                    ],
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('> [${DateFormat('MM/dd/hh:mm:ss').format(logs[index].dateTime)}]', style: Styles.defaultStyleGrey13),
                      Text(' ${logs[index].content}', style: logs[index].isError ? Styles.defaultStyleRed13 : Styles.defaultStyleGreen13, softWrap: true,),
                    ],
                  );
                }
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                  controller: textController,
                  cursorColor: Styles.primaryColor,
                  style: Styles.defaultStyleGreen18,
                  focusNode: focusNode,
                  autofocus: false,
                  decoration: InputDecoration(
                    fillColor: bgColor,
                    filled: true,
                    prefixIconColor: Styles.primaryColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1),
                      borderSide: const BorderSide(
                        color: Styles.hiddenColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1),
                      borderSide: const BorderSide(
                        color: Styles.primaryColor,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.navigate_next),
                    hintText: 'type command here',
                    hintStyle: Styles.defaultStyle18,
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.go,
                  onTap: () {
                    FocusScope.of(context).requestFocus(focusNode);
                    scrollToBottom();
                  },
                  onSubmitted: (value){
                    insertLog(
                      ConsoleLog(dateTime: DateTime.now(), content: textController.text, isError: false, fromRobot: false),
                    );
                    ref.read(webSocketProvider).sendMessage(value);
                    textController.clear();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  fetchConsoleLog() async {
    List<Map<String, dynamic>> result = await dbHelper.getAllData('consoleLogTable');
    logs = result.map((map) => ConsoleLog.fromMap(map)).toList();
    scrollToBottom();
  }

  insertLog(ConsoleLog log) async {
    dbHelper.insertData('consoleLogTable', log.toMap()).then((value){
      fetchConsoleLog();
    });
  }
  
  updateLog(ConsoleLog log) async {
    await dbHelper.updateData('consoleLogTable',log.id!, log.toMap());
    fetchConsoleLog();
  }

  deleteLog(ConsoleLog log) async {
    await dbHelper.deleteData('consoleLogTable', log.id!);
    fetchConsoleLog();
  }

  void scrollToBottom() {
    // if (scrollController.hasClients) {
    //   scrollController.animateTo(
    //     scrollController.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 100),
    //     curve: Curves.easeOut,
    //   );
    // }
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
  
  Future<void> initConnectivity() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    await updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi) {
      try {
        final currentSsid = await networkInfo.getWifiName();
        if (!mounted) return;
        setState(() {
          ssid = currentSsid ?? 'Unknown SSID';
        });
      } catch (e) {
        print(e.toString());
      }
    } else {
      if (!mounted) return;
      setState(() {
        ssid = 'not connected to Wi-Fi';
      });
    }
  }
}