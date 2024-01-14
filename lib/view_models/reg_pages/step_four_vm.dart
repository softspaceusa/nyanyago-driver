import 'package:flutter/material.dart';
import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/globals.dart';
import 'package:nanny_driver/views/reg_pages.dart/step_five.dart';

class RegStepFourVM extends ViewModelBase {
  RegStepFourVM({
    required super.context,
    required super.update,
  }) {
    DioRequest.updateToken(NannyConsts.regFileToken);
  }

  DriverUserData regForm = NannyDriverGlobals.driverRegForm;

  bool get photoLoaded => photoPath.isNotEmpty;
  bool get videoLoaded => videoPath != null && videoPath!.isNotEmpty;

  GlobalKey<FormState> aboutMeState = GlobalKey();
  GlobalKey<FormState> ageState = GlobalKey();

  String aboutMe = "";
  String age = "";

  String photoPath = "";
  String? videoPath;

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

  void getVideo() async {
    var video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if(video == null) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, true);

    var upload = NannyFilesApi.uploadFiles([video]);
    bool success = await DioRequest.handleRequest(
      context, 
      upload,
    );

    if(!context.mounted) return;
    if(!success) return;
    
    LoadScreen.showLoad(context, false);

    videoPath = (await upload).response!.paths.first;
    update(() {});
  }

  void nextStep() {
    if(!aboutMeState.currentState!.validate() ||
       !ageState.currentState!.validate()
    ) return;

    if(!photoLoaded) {
      NannyDialogs.showMessageBox(context, "Фото", "Загрузите фото!");
      return;
    }

    regForm.driverData = regForm.driverData.copyWith(
      age: int.parse(age),
      description: aboutMe,
    );

    regForm.userData = regForm.userData.copyWith(
      photoPath: photoPath,
      videoPath: videoPath,
    );

    slideNavigateToView(const RegStepFiveView());
  }
}