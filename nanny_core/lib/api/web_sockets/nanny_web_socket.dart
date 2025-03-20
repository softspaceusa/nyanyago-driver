import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class NannyWebSocket {
  NannyWebSocket(this.tag, this.currentAddress);

  final String tag;
  final String currentAddress;
  WebSocketChannel? channel;
  WebSocketSink? sink;
  StreamSubscription? sub;

  final _controller =
      StreamController<String>.broadcast(); // ✅ Для нескольких подписчиков
  Stream<String> get stream => _controller.stream; // ✅ Получаем стрим

  bool _connected = false;
  int _retryCount = 0;
  final int maxRetries = 5;
  final Duration retryDelay = const Duration(seconds: 3);

  bool get connected => _connected;
  String get address => currentAddress;

  /// Подключение к WebSocket
  Future<NannyWebSocket> connect() async {
    try {
      print("🔌 [WebSocket] Подключение к $currentAddress ($tag)...");

      channel = WebSocketChannel.connect(Uri.parse(currentAddress));
      sink = channel?.sink;
      await channel?.ready;
      _connected = true;
      _retryCount = 0;

      print("✅ [WebSocket] Успешное подключение ($tag) к $currentAddress");

      sub = channel?.stream.listen(
        (data) {
          print("📩 [WebSocket] Данные ($tag): $data");
          _controller.add(data); // ✅ Передача данных в StreamController
        },
        onError: (error) async {
          print("❌ [WebSocket] Ошибка ($tag): $error");
          _connected = false;
          await reconnect();
        },
        onDone: () async {
          print("⚠️ [WebSocket] Поток закрыт ($tag). Переподключение...");
          _connected = false;
          await reconnect();
        },
        cancelOnError: true,
      );

      return this;
    } catch (e) {
      print("❌ [WebSocket] Ошибка подключения ($tag): $e");
      reconnect();
      rethrow;
    }
  }

  /// Переподключение WebSocket
  Future reconnect() async {
    if (_retryCount >= maxRetries) {
      print("⏳ [WebSocket] Достигнут лимит попыток ($maxRetries)");
      return;
    }

    _retryCount++;
    print(
        "🔄 [WebSocket] Попытка #$_retryCount через ${retryDelay.inSeconds} сек...");

    Future.delayed(retryDelay, () async {
      if (!_connected) {
        await connect();
      }
    });
  }

  /// Отправка данных через WebSocket
  Future<void> sinkValue(Map<String, dynamic> v, {bool encode = true}) async {
    try {
      final message = encode ? jsonEncode(v) : v;
      print("📤 [WebSocket] Отправка ($tag): $message");
      sink?.add(message);
    } catch (e) {
      print("❌ [WebSocket] Ошибка при отправке ($tag): $e");
      _connected = false;
      await reconnect();
    }
  }

  /// Закрытие WebSocket
  void dispose() {
    print("🛑 [WebSocket] Закрытие ($tag)...");
    sub?.cancel();
    sink?.close();
    _controller.close();
    _connected = false;
  }
}
