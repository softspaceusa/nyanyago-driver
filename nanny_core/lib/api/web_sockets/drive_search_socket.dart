import 'package:nanny_core/api/web_sockets/nanny_web_socket.dart';
import 'package:nanny_core/constants.dart';

class DriveSearchSocket extends NannyWebSocket {
  DriveSearchSocket()
      : super('DriveSearchSocket',
            "${NannyConsts.socketUrl}/orders/search-driver");

  @override
  String get address => "${NannyConsts.socketUrl}/orders/search-driver";
}
