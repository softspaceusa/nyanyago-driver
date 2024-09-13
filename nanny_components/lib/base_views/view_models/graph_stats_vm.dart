import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/request_builder.dart';
import 'package:nanny_core/nanny_core.dart';

class GraphStatsVM extends ViewModelBase{
  GraphStatsVM({
    required super.context, 
    required super.update,
    required this.getUsersReport,
  });
  
  final bool getUsersReport;
  DateType selectedDateType = DateType.day;
  List<double> data = [];

  void onSelect(Set<DateType> type) {
    update(() => selectedDateType = type.first);
    reloadPage();
  }

  void downloadReport() async {
    var dir = await getDownloadsDirectory();

    if(dir == null) {
      if(context.mounted) {
        NannyDialogs.showMessageBox(
          context, 
          "Ошибка", 
          "Не удалось получить директорию для загрузки файла!"
        );
      }
      return;
    }

    
    var res = await (getUsersReport ? NannyAdminApi.downloadUsersReport(
      period: selectedDateType, 
      type: PeriodType.graph, 
    )
    : NannyAdminApi.downloadSalesReport(
      period: selectedDateType, 
      type: PeriodType.graph, 
    ));

    if(res.response == null) return;
    String url = res.response!;
    String path = "${dir.path}/${url.split('/').last}";

    if(!res.success) {
      if(context.mounted) {
        NannyDialogs.showMessageBox(context, "Ошибка", "Не удалось загрузить файлы!");
      }
      return;
    }
    if(!context.mounted) return;

    double downloaded = 0;
    void Function() updateLoad = () {};
    late BuildContext loadContext;
    CancelToken cancelToken = CancelToken();
    NannyDialogs.showModalDialog(
      context: context, 
      hasDefaultBtn: false,
      title: "Отменить загрузку",
      child: StatefulBuilder(
        builder: (lContext, setState) {
          updateLoad = () => setState(() {});
          loadContext = lContext;

          return Column(
            children: [
              SizedBox.square(
                dimension: 60,
                child: FittedBox(
                  child: LoadingView(progress: downloaded / 100)
                ),
              ),
              const SizedBox(height: 10),
              Text("${downloaded.toStringAsFixed(0)} %")
            ],
          );
        },
      ),
    ).then((value) {
      if(value) cancelToken.cancel();
    });

    var downRes = await RequestBuilder<void>().create(
      dioRequest: DioRequest.dio.downloadUri(
        Uri.parse("${NannyConsts.baseUrl}/files/${url.split('/').last}"),
        path,
        onReceiveProgress: (count, total) {
          downloaded = (count / total) * 100;
          updateLoad();
        },
        cancelToken: cancelToken
      )
    );

    if(loadContext.mounted) Navigator.pop(loadContext);

    if(!downRes.success) {
      if(context.mounted) {
        NannyDialogs.showMessageBox(context, "Ошибка", "Не удалось загрузить файлы или загрузка была отменена");
      }
      return;
    }

    OpenFile.open(path);
  }

  @override
  Future<bool> loadPage() async {
    var res = await (
      getUsersReport ? 
      NannyAdminApi.getUsersReportGraph(selectedDateType) : 
      NannyAdminApi.getSalesReportGraph(selectedDateType)
    );

    if(!res.success) return false;
    data = res.response!;
    
    return true;
  }
}