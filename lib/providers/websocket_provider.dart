////////////////////////////////////////////////////////////////////////////////////////////
/// import
////////////////////////////////////////////////////////////////////////////////////////////

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:robo_debug_app/components/snackbar.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum ConnectionStatusType { connected, connecting, disconnected }

class WebSocketProvider extends ChangeNotifier {
  
  WebSocketChannel? _channel;
  
  ConnectionStatusType _status = ConnectionStatusType.disconnected;
  String _statusMessage = "";

  get channel => _channel;

  get status  => _status;

  get statusMessage => _statusMessage;

  void connect(String uri) {
    // 接続状態を「接続中」に更新し、変更を通知
    updateStatus(ConnectionStatusType.connecting, "Connecting to $uri ...", SnackBarType.info);

    try {
      if (_channel != null) {
        _channel?.sink.close();
      }
      _channel = IOWebSocketChannel.connect(Uri.parse(uri));
      _channel!.stream.listen(
        (message) {
          // 接続成功時の処理
          if(_status == ConnectionStatusType.connecting){
            updateStatus(ConnectionStatusType.connected, "Connected to $uri", SnackBarType.info);
          }else{
            receiveMessage(message);
          }
        },
        onError: (error) {
          // ストリームエラー時の処理
          updateStatus(_status, "Stream error: $error", SnackBarType.error);
        },
      );
    } catch (e) {
      // 接続試み時の同期エラー処理
      updateStatus(ConnectionStatusType.disconnected, e is SocketException ? "SocketException: ${e.message}" : "Exception: $e", SnackBarType.error);
    }
  }

  void sendMessage(dynamic message) {
    if (_channel != null && _status == ConnectionStatusType.connected) {
      _channel!.sink.add(message);
      updateStatus(ConnectionStatusType.connected, "send '$message'", SnackBarType.info);
    } else {
      // WebSocketが接続されていない場合の処理
      updateStatus(_status, "WebSocket Channel is not connected", SnackBarType.error,);
    }
  }

  void cannceled() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
      updateStatus(ConnectionStatusType.disconnected, "Canceled", SnackBarType.warning);
    }
  }

  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
      updateStatus(ConnectionStatusType.disconnected, "Disconnected", SnackBarType.warning);
    }
  }

  void updateStatus(ConnectionStatusType status, String message, SnackBarType snackBarType) {
    _status  = status;
    _statusMessage = message;

    notifyListeners();

    showSnackBar(
      message: message,
      type: snackBarType,
      duration: const Duration(seconds: 5),
    );
  }

  void receiveMessage(String message) {

    notifyListeners();

    showSnackBar(
      message: "Received message: $message",
      type: SnackBarType.info,
      duration: const Duration(seconds: 5),
    );
  }
}
