import 'dart:async';
import 'dart:convert';
import 'package:nanny_core/nanny_core.dart';

class NannyWebSocket {
  NannyWebSocket(this.tag, this.currentAddress);

  NannyWebSocket._(
    this.tag,
    this.currentAddress, {
    required this.channel,
    required this.stream,
    required this.sink,
  }) {
    _sub = stream.listen(
      (data) {
        Logger().i(
            "📩 [WebSocket] Получены данные ($tag):\n$data\n🔗 Адрес: $currentAddress");
      },
      onError: (error) async {
        Logger().e("❌ [WebSocket] Ошибка в потоке ($tag): $error");
        _connected = false;
        await reconnect();
      },
      onDone: () async {
        Logger().w(
            "⚠️ [WebSocket] Поток закрыт ($tag). Попытка переподключения...");
        _connected = false;
        await reconnect();
      },
      cancelOnError: true,
    );
    _connected = true;
  }

  final String tag;
  final String currentAddress;
  late WebSocketChannel channel;
  late Stream stream;
  late WebSocketSink sink;
  late final StreamSubscription _sub;

  bool _connected = false;
  int _retryCount = 0;
  final int maxRetries = 5;
  final Duration retryDelay = Duration(seconds: 3);

  bool get connected => _connected;
  String get address => currentAddress;

  /// Подключение к WebSocket
  Future<NannyWebSocket> connect() async {
    try {
      Logger().i("🔌 [WebSocket] Подключение к $currentAddress ($tag)...");

      channel = WebSocketChannel.connect(Uri.parse(currentAddress));
      await channel.ready;
      _connected = true;
      _retryCount = 0;

      Logger().i("✅ [WebSocket] Успешное подключение ($tag) к $currentAddress");

      return NannyWebSocket._(
        tag,
        currentAddress,
        channel: channel,
        stream: channel.stream.asBroadcastStream(),
        sink: channel.sink,
      );
    } catch (e) {
      Logger().e("❌ [WebSocket] Ошибка подключения ($tag): $e");
      reconnect();
      rethrow;
    }
  }

  /// Переподключение WebSocket
  Future reconnect() async {
    if (_retryCount >= maxRetries) {
      Logger()
          .w("⏳ [WebSocket] Достигнут лимит попыток подключения ($maxRetries)");
      return;
    }

    _retryCount++;
    Logger().w(
        "🔄 [WebSocket] Попытка переподключения #$_retryCount через ${retryDelay.inSeconds} сек...");

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
      Logger().i("📤 [WebSocket] Отправка данных ($tag): $message");
      sink.add(message);
    } catch (e) {
      Logger().e("❌ [WebSocket] Ошибка при отправке ($tag): $e");
      _connected = false;
      await reconnect();
    }
  }

  /// Закрытие WebSocket
  void dispose() {
    Logger().w("🛑 [WebSocket] Закрытие ($tag)...");
    _sub.cancel();
    sink.close();
    _connected = false;
  }
}
