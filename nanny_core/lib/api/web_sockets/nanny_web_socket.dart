import 'dart:async';

import 'package:nanny_core/nanny_core.dart';

class NannyWebSocket {
  NannyWebSocket();

  NannyWebSocket._({
    required this.channel,
    required this.stream,
    required this.sink,
  }) {
    _sub = stream.listen((data) {
      Logger().i("Got data:\n$data\nFrom address: $address");
    });
    _connected = true;
  }

  late final WebSocketChannel channel;
  late final Stream stream;
  late final WebSocketSink sink;

  late final StreamSubscription _sub;

  bool _connected = false;

  bool get connected => _connected;

  String get address => "";

  Future<NannyWebSocket> connect() async {
    channel = WebSocketChannel.connect(Uri.parse(address));
    await channel.ready;
    _connected = true;

    Logger().w("Inited websocket at address: $address");

    return NannyWebSocket._(
      channel: channel,
      stream: channel.stream.asBroadcastStream(),
      sink: channel.sink,
    );
  }

  void dispose() {
    sink.close();
    _sub.cancel();
  }
}
