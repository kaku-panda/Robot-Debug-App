import 'package:flutter/material.dart';
import 'package:robo_debug_app/components/button.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  List<String> messages = [];
  late WebSocketChannel channel;

  bool isLoading = false;
  bool isOnRed   = false;
  bool isOnGreen = false;
  bool isOnBlue  = false;
  
  String? ssid = "unknown";

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
  }

  void connectToWebSocket() async {
    isLoading = true;
    setState(() {});
    try {
      channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.42.1:8081'));
      channel.stream.listen((message) {
        setState(() {
          messages.add(message);
        });
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
 
  void reconnectToWebSocket() async {
    setState(() {
      isLoading = true;
    });
    try {
      channel.sink.close();
      channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.42.1:8081'));
      channel.stream.listen((message) {
        setState(() {
          messages.add(message);
        });
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  } 

  void sendMessage(String message) {
    String send_message = "";
    
    if (!isLoading) {
      if(message == "red"){
        send_message = (isOnRed) ? "red off" : "red on";
        isOnRed = !isOnRed;
      }
      if(message == "green"){
        send_message = (isOnGreen) ? "green off" : "green on";
        isOnGreen = !isOnGreen;
      }
      if(message == "blue"){
        send_message = (isOnBlue) ? "blue off" : "blue on";
        isOnBlue = !isOnBlue;
      }
      channel.sink.add(send_message);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    // リクエストを出す処理
    LocationPermissionsHandler().request();

    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket App'),
      ),
      body: Center(
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                CustomTextButton(
                  text: "Red",
                  backgroundColor: Colors.red,
                  enable: isOnRed,
                  width: 60,
                  height: 40,
                  onPressed: (){
                    sendMessage("red");
                  }
                ),
                CustomTextButton(
                  text: "Green",
                  backgroundColor: Colors.green,
                  enable: isOnGreen,
                  width: 60,
                  height: 40,
                  onPressed: (){
                    sendMessage("green");
                  }
                ),
                CustomTextButton(
                  text: "Blue",
                  backgroundColor: Colors.blue,
                  enable: isOnBlue,
                  width: 60,
                  height: 40,
                  onPressed: (){
                    sendMessage("blue");
                  }
                )
              ],
            ),
            ElevatedButton(
              onPressed: isLoading ? null : reconnectToWebSocket,
              child: isLoading ? const CircularProgressIndicator() : const Text('Reconnect'),
            ),
            Text(ssid ?? 'unknown'),
            ElevatedButton(
              onPressed: () async {
                // Check if the device is connected to Wi-Fi
                final ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.wifi) {
                  // Get the current Wi-Fi network's SSID
                  ssid = await NetworkInfo().getWifiBSSID();
                  print('SSID: $ssid');
                  ssid = await NetworkInfo().getWifiName();
                  print('SSID: $ssid');
                  ssid = await NetworkInfo().getWifiIP();
                  print('SSID: $ssid');
                  ssid = await NetworkInfo().getWifiGatewayIP();
                  print('SSID: $ssid');

                } else {
                  print('Device is not connected to Wi-Fi');
                }// Check if the device is connected to Wi-Fi
              },
              child: Text("get ssid"),
            ),
          ],
        ),
      ),
    );
  }
}


enum LocationPermissionStatus { granted, denied, permanentlyDenied, restricted }

class LocationPermissionsHandler {
  Future<bool> get isGranted async {
    final status = await Permission.location.status;
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        return false;
      default:
        return false;
    }
  }

  Future<bool> get isAlwaysGranted {
    return Permission.locationAlways.isGranted;
  }

  Future<LocationPermissionStatus> request() async {
    final status = await Permission.location.request();
    switch (status) {
      case PermissionStatus.granted:
        return LocationPermissionStatus.granted;
      case PermissionStatus.denied:
        return LocationPermissionStatus.denied;
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return LocationPermissionStatus.permanentlyDenied;
      case PermissionStatus.restricted:
        return LocationPermissionStatus.restricted;
      default:
        return LocationPermissionStatus.denied;
    }
  }
}