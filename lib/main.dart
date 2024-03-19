import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  bool isLoading = false; // 接続中かどうかを管理するフラグ

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
    if (!isLoading) {
      channel.sink.add(message);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket App'),
      ),
      body: Center(
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => sendMessage('red'),
              child: const Text('Red'),
            ),
            ElevatedButton(
              onPressed: () => sendMessage('green'),
              child: const Text('Green'),
            ),
            ElevatedButton(
              onPressed: () => sendMessage('blue'),
              child: const Text('Blue'),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : reconnectToWebSocket,
              child: isLoading ? const CircularProgressIndicator() : const Text('Reconnect'),
            ),
          ],
        ),
      ),
    );
  }
}
