import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/views/driver_info.dart';
import 'package:nanny_components/base_views/views/video_view.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/franchise/view_models/driver_management/driver_list_vm.dart';

class DriversListView extends StatefulWidget {
  const DriversListView({super.key});

  @override
  State<DriversListView> createState() => _DriversListViewState();
}

class _DriversListViewState extends State<DriversListView>
    with AutomaticKeepAliveClientMixin {
  late DriverListVM vm;

  @override
  void initState() {
    super.initState();
    vm = DriverListVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    if (wantKeepAlive) super.build(context);
    print(DioRequest.authToken);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent),
          child: CheckboxListTile(
              title: Text("Показать заявки новых водителей",
                  style: Theme.of(context).textTheme.labelLarge),
              value: vm.showNewDrivers,
              onChanged: vm.listTypeChanged,
              activeColor: NannyTheme.primary),
        ),
        Expanded(
          child: FranchiseDriverList(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 37),
              showNewDrivers: vm.showNewDrivers,
              excludeFilter: false,
              filterItems: const ['По статусу', 'По дате'],
              itemLabel: (item) => item,
              onItemChanged: (item) {},
              onDriverTap: (user) => vm.showNewDrivers
                  ? () => vm.toNewDriverRequest(user.id)
                  : NannyDialogs.showModalDialog(
                      context: context,
                      hasDefaultBtn: false,
                      title: "Статус водителя",
                      child: Padding(
                        padding: const EdgeInsets.only(top: 43),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProfileImage(
                                    url: user.photoPath,
                                    radius: 100,
                                    padding: EdgeInsets.zero,
                                  ),
                                  const SizedBox(width: 27),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${user.name} ${user.surname}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                height: 20 / 18,
                                                color: NannyTheme.onSecondary),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                        if (user.videoPath.isNotEmpty)
                                          TextButton(
                                            style: const ButtonStyle(
                                              padding: WidgetStatePropertyAll(
                                                  EdgeInsets.zero),
                                            ),
                                            onPressed: user.videoPath.isNotEmpty
                                                ? () => vm.navigateToView(
                                                    VideoView(
                                                        url: user.videoPath))
                                                : null,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons
                                                      .play_circle_outline_outlined,
                                                  color: Color(0xFF6D6D6D),
                                                ),
                                                const SizedBox(width: 3),
                                                GestureDetector(
                                                  onTap: () =>
                                                      vm.navigateToView(
                                                    VideoView(
                                                        url: user.videoPath),
                                                  ),
                                                  child: const Text(
                                                    "Видео-описание",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 17.6 / 16,
                                                      color: Color(0xFF6D6D6D),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        Text(
                                          "Статус: ${user.jsonData['status'] ?? user.status}\n"
                                          "Дата регистрации: ${DateFormat("dd.MM.yyyy").format(
                                            DateTime.parse(user.dateReg),
                                          )}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 16.8 / 12,
                                            color: Color(0xFF2B2B2B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 27),
                            ElevatedButton.icon(
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 14),
                                ),
                                minimumSize: WidgetStatePropertyAll(
                                  Size(double.infinity, 42),
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () => vm
                                  .navigateToView(DriverInfoView(id: user.id)),
                              label: const Text("Просмотреть профиль"),
                              icon: const Icon(Icons.person),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton.icon(
                              onPressed: () => vm.banUser(
                                user,
                                previewDialogContexts: [context],
                              ),
                              style: const ButtonStyle(
                                alignment: Alignment.centerLeft,
                                elevation: WidgetStatePropertyAll(0),
                                foregroundColor:
                                    WidgetStatePropertyAll(Color(0xFF212121)),
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 14),
                                ),
                                minimumSize: WidgetStatePropertyAll(
                                  Size(double.infinity, 42),
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              label: Text(user.status == UserStatus.active
                                  ? "Заблокировать"
                                  : "Разблокировать"),
                              icon: const Icon(
                                Icons.block,
                                color: Color(0xFFFF5252),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
