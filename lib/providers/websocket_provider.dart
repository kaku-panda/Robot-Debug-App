////////////////////////////////////////////////////////////////////////////////////////////
/// import
////////////////////////////////////////////////////////////////////////////////////////////

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:robo_debug_app/components/snackbar.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum ConnectionStatusType { connected, connecting, disconnected }

class WebSocketProvider extends ChangeNotifier {
  
  WebSocketChannel? _channel;
  
  ConnectionStatusType _status = ConnectionStatusType.disconnected;
  String _message = "";

  get channel => _channel;

  get status  => _status;

  get message => _message;

  void connect(String uri) {
    // 接続状態を「接続中」に更新し、変更を通知
    updateStatus(ConnectionStatusType.connecting, "Connecting to $uri...", SnackBarType.info);

    try {
      if (_channel != null) {
        _channel?.sink.close();
      }
      _channel = IOWebSocketChannel.connect(Uri.parse(uri));

      _channel!.stream.listen(
        (message) {
          // 接続成功時の処理
          updateStatus(ConnectionStatusType.connected, "Connected to $uri", SnackBarType.info);
        },
        onError: (error) {
          // ストリームエラー時の処理
          updateStatus(ConnectionStatusType.disconnected, "Stream error: $error", SnackBarType.error);
        },
      );
    } catch (e) {
      // 接続試み時の同期エラー処理
      updateStatus(ConnectionStatusType.disconnected, e is SocketException ? "SocketException: ${e.message}" : "Exception: $e", SnackBarType.error);
    }
  }

  void sendMessage(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    } else {
      // WebSocketが接続されていない場合の処理
      updateStatus(ConnectionStatusType.disconnected, "WebSocket Channel is not connected", SnackBarType.error);
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
    _message = message;

    notifyListeners();

    showSnackBar(
      message: message,
      type: snackBarType,
      duration: const Duration(seconds: 5),
    );
  }
}
