import 'package:nanny_core/nanny_core.dart';

class DeclineRoadsRequests implements NannyBaseRequest {
  DeclineRoadsRequests();

  List<int> idRoads = [];

  @override
  Map<String, dynamic> toJson() => {"id_road": idRoads};
}
