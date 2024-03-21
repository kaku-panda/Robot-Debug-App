////////////////////////////////////////////////////////////////////////////////////////////
/// import
////////////////////////////////////////////////////////////////////////////////////////////
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:robo_debug_app/components/snackbar.dart';
import 'package:robo_debug_app/components/style.dart';
import 'package:robo_debug_app/database/console_log.dart';

// my package
import 'package:robo_debug_app/main.dart';
import 'package:robo_debug_app/database/database_helper.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  late WebSocketChannel channel;

  // TextField の動作をスムーズにするための変数
  final FocusNode focusNode = FocusNode();
  final TextEditingController textController = TextEditingController();

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
    initConnectivity();
    channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.42.1:8081'));
    connectivitySubscription = Connectivity().onConnectivityChanged.listen(updateConnectionStatus);
    logs = [];
    fetchConsoleLog();
    super.initState();
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    channel.sink.close();
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
            icon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.connect_without_contact, size: 30),
            ),
            onPressed: (){
              reconnectToWebSocket();
            },
          )
        ],
      ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: logs.length,
                    itemBuilder: (context, index){
                      return logs[index].fromRobot ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${logs[index].content} ', style: logs[index].isError ? Styles.defaultStyleRed15 : Styles.defaultStyleGreen15),
                          Text('[${DateFormat('MM/dd/hh:mm:ss').format(logs[index].dateTime)}] <', style: Styles.defaultStyleGrey13),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('> [${DateFormat('MM/dd/hh:mm:ss').format(logs[index].dateTime)}]', style: Styles.defaultStyleGrey13),
                          Text(' ${logs[index].content}', style: logs[index].isError ? Styles.defaultStyleRed15 : Styles.defaultStyleGreen15),
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
                      },
                      onSubmitted: (value){
                        ConsoleLog newLog = ConsoleLog(dateTime: DateTime.now(), content: textController.text, isError: false, fromRobot: false);
                        insertLog(newLog);
                        scrollToBottom();
                        sendMessage(value);
                        textController.clear();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // データベースの内容をページに反映
  fetchConsoleLog() async {
    List<Map<String, dynamic>> result = await dbHelper.getAllData();
    setState(() {
      logs = result.map((map) => ConsoleLog.fromMap(map)).toList();
    });
  }

  insertLog(ConsoleLog log) async {
    await dbHelper.insertData(log.toMap());
    fetchConsoleLog();
  }
  
  updateLog(ConsoleLog log) async {
    await dbHelper.updateData(log.id!, log.toMap());
    fetchConsoleLog();
  }

  deleteLog(ConsoleLog log) async {
    await dbHelper.deleteData(log.id!);
    fetchConsoleLog();
  }

  // scrollbar
  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }
  
  void reconnectToWebSocket() async {
    showSnackBar(
      context: context,
      message: 'connectting to ws://${ref.watch(settingProvider).webSocketAddress}',
      type: SnackBarType.info
    );
    try {
      channel.sink.close();
      channel = IOWebSocketChannel.connect(Uri.parse('ws://${ref.read(settingProvider).webSocketAddress}'));
      channel.stream.timeout(
        const Duration(seconds: 10),
        onTimeout: (sink) {
          sink.addError('Connection timed out');
          showSnackBar(
            context: context,
            message: 'Connection timed out',
            type: SnackBarType.error
          );
        },
      ).listen((message) {
        showSnackBar(
          context: context,
          message: message,
          type: SnackBarType.info
        );
      });
    } catch (e) {
      showSnackBar(
        context: context,
        message: e.toString(),
        type: SnackBarType.error
      );
    }
  }

  void sendMessage(String message) {
    showSnackBar(
      context: context,
      message: 'send $message',
      type: SnackBarType.info
    );
    channel.sink.add(message);
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