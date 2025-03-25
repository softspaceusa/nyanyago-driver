import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  DriverUserData regForm = NannyDriverGlobals.driverRegForm;

  bool get photoLoaded => photoPath.isNotEmpty;
  bool get videoLoaded => videoPath != null && videoPath!.isNotEmpty;

  GlobalKey<FormState> aboutMeState = GlobalKey();
  GlobalKey<FormState> ageState = GlobalKey();
  TextEditingController ageController = TextEditingController();

  String aboutMe = "";
  String age = "";

  String photoPath = "";
  String? videoPath;

  void getPicture() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.isEmpty) return null;
    if (!context.mounted) return null;

    LoadScreen.showLoad(context, true);

    var upload = NannyFilesApi.uploadFiles([result.files.first]);
    bool success = await DioRequest.handleRequest(
      context,
      upload,
    );

    if (!context.mounted) return;
    if (!success) return;

    LoadScreen.showLoad(context, false);

    photoPath = (await upload).response!.paths.first;
    update(() {});
  }

  void getVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null || result.files.isEmpty) return null;
    if (!context.mounted) return null;

    LoadScreen.showLoad(context, true);

    var upload = NannyFilesApi.uploadFiles([result.files.first]);
    bool success = await DioRequest.handleRequest(
      context,
      upload,
    );

    if (!context.mounted) return;
    if (!success) return;

    LoadScreen.showLoad(context, false);

    videoPath = (await upload).response!.paths.first;
    update(() {});
  }

  void nextStep() {
    if (!aboutMeState.currentState!.validate() ||
        !ageState.currentState!.validate()) return;

    if (!photoLoaded) {
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

    Navigator.of(context).pushNamed('step5');
  }
}
