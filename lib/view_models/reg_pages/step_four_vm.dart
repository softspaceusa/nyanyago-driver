import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class RegStepFourVM extends ViewModelBase {
  RegStepFourVM({
    required super.context,
    required super.update,
  });

  String aboutMe = "";
  String age = "";

  void getPicture() async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(picture == null) return;

    
  }

  void nextStep() {

  }
}