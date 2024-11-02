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
    _sub = stream.listen((data) {
      Logger().i("Got data on $tag:\n$data\nFrom address: $currentAddress");
    });
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

  String get address => "";

  Future<NannyWebSocket> connect() async {
    channel = WebSocketChannel.connect(Uri.parse(currentAddress));
    await channel.ready;
    _connected = true;
    Logger().w("Inited $tag websocket at address: $currentAddress");

    return NannyWebSocket._(
      tag,
      currentAddress,
      channel: channel,
      stream: channel.stream.asBroadcastStream(),
      sink: channel.sink,
    );
  }

  Future<void> sinkValue(dynamic v,
      {bool encode = true, bool thenDecode = false}) async {
    try {
      sink.add(jsonEncode(v));
    } catch (e) {
      _connected = false;
      await sink.close();
      print('cannot sink data $v');
      channel = WebSocketChannel.connect(Uri.parse(currentAddress));
      await channel.ready;
      _connected = true;
    }
  }

  void dispose() {
    sink.close();
    _sub.cancel();
  }
}
