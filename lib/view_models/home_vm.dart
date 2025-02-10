import 'package:nanny_components/nanny_components.dart';

class HomeVM extends ViewModelBase {
  HomeVM({
    required super.context,
    required super.update,
  }) {
    initialSetup();
  }

  int currentIndex = 1;
  void indexChanged(int index) => update(() => currentIndex = index);
  void initialSetup() async {
    //await NannyGlobals.initChatSocket();
    //FirebaseMessagingHandler.checkInitialMessage();
  }
}
