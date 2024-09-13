import 'package:nanny_core/api/request_builder.dart';
import 'package:nanny_core/nanny_core.dart';

class NannyFilesApi {
  static Future<ApiResponse<UploadedFiles>> uploadFiles(List<XFile> files) async {
    var formData = FormData();
    for (var file in files) {
      var formFile = await MultipartFile.fromFile(
        file.path,
        filename: file.name.substring(0, file.name.length < 10 ? file.name.length : 10),
        contentType: MediaType.parse("multipart/form-data")
      );

      formData.files.add(MapEntry('files', formFile));
    }

    return RequestBuilder<UploadedFiles>().create(
      dioRequest: DioRequest.dio.post("/files/upload_files", data: formData),
      onSuccess: (response) => UploadedFiles.fromJson(response.data),
    );
  }
}