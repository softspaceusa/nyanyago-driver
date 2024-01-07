import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/globals.dart';

class RegStepFourVM extends ViewModelBase {
  RegStepFourVM({
    required super.context,
    required super.update,
  }) {
    DioRequest.updateToken(NannyConsts.regFileToken);
  }

  DriverRegData regForm = NannyDriverGlobals.driverRegForm;

  bool get photoLoaded => photoPath.isNotEmpty;
  bool get videoLoaded => videoPath.isNotEmpty;

  String aboutMe = "";
  String age = "";

  String photoPath = "";
  String videoPath = "";

  void getPicture() async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(picture == null) return;
    if(!context.mounted) return;
    
    LoadScreen.showLoad(context, true);

    var upload = NannyFilesApi.uploadFiles([picture]);
    bool success = await DioRequest.handleRequest(
      context, 
      upload,
    );

    if(!context.mounted) return;
    if(!success) return;
    
    LoadScreen.showLoad(context, false);

    photoPath = (await upload).response!.paths.first;
    update(() {});
  }

  void getVideo() {

  }

  void nextStep() {

  }
}