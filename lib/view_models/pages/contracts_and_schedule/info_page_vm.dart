import 'package:nanny_components/nanny_components.dart';

class InfoPageVM extends ViewModelBase {
  InfoPageVM({
    required super.context, 
    required super.update,
  });

  bool showContracts = false;

  void changeShowContract(bool show) => update(() => showContracts = show);
}