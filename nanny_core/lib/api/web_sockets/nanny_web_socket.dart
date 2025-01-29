import 'dart:async';

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
      onError: (error) {
        Logger().e("❌ [WebSocket] Ошибка в потоке ($tag): $error");
      },
      onDone: () {
        Logger().w("⚠️ [WebSocket] Поток закрыт ($tag)");
        _connected = false;
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

  bool get connected => _connected;

  String get address => currentAddress;

  Future<NannyWebSocket> connect() async {
    try {
      Logger().i("🔌 [WebSocket] Подключение к $currentAddress ($tag)...");
      channel = WebSocketChannel.connect(Uri.parse(currentAddress));
      await channel.ready;
      _connected = true;
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
      rethrow;
    }
  }

  Future<void> sinkValue(Map<String, dynamic> v,
      {bool encode = true, bool thenDecode = false}) async {
    try {
      //final message = encode ? jsonEncode(v) : v;
      Logger().i("📤 [WebSocket] Отправка данных ($tag): $v");
      sink.add(v);
    } catch (e) {
      Logger().e("❌ [WebSocket] Ошибка при отправке ($tag): $e");
      _connected = false;
      await sink.close();
      Logger().i("🔄 [WebSocket] Переподключение ($tag)...");
      channel = WebSocketChannel.connect(Uri.parse(currentAddress));
      await channel.ready;
      _connected = true;
      Logger().i("✅ [WebSocket] Успешное переподключение ($tag)");
    }
  }

  void dispose() {
    Logger().w("🛑 [WebSocket] Закрытие ($tag)...");
    sink.close();
    _sub.cancel();
    _connected = false;
  }
}
