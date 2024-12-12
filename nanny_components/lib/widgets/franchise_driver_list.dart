import 'package:flutter/material.dart';
import 'package:nanny_components/styles/nanny_theme.dart';
import 'package:nanny_components/widgets/future_handlers/request_loader.dart';
import 'package:nanny_components/widgets/profile_image.dart';
import 'package:nanny_components/widgets/states/error_view.dart';
import 'package:nanny_core/api/nanny_franchise_api.dart';
import 'package:nanny_core/nanny_core.dart';

class FranchiseDriverList<T> extends StatefulWidget {
  final bool persistState;

  final List<T> filterItems;
  final String Function(T item) itemLabel;
  final void Function(T? item) onItemChanged;
  final void Function(UserInfo<void> user) onDriverTap;
  final bool showNewDrivers;
  final EdgeInsets? padding;
  final bool showRequestMoney;
  final Map<String, dynamic>? queryParameters;
  final bool excludeFilter;

  const FranchiseDriverList(
      {super.key,
      required this.filterItems,
      required this.itemLabel,
      required this.onItemChanged,
      required this.onDriverTap,
      required this.showNewDrivers,
      this.persistState = false,
      this.padding,
      this.showRequestMoney = false,
      this.queryParameters,
      this.excludeFilter = true});

  @override
  State<FranchiseDriverList> createState() => _FranchiseDriverListState<T>();
}

class _FranchiseDriverListState<T> extends State<FranchiseDriverList<T>>
    with AutomaticKeepAliveClientMixin {
  String status = '';

  @override
  void initState() {
    status = widget.filterItems.isNotEmpty
        ? widget.filterItems.first.toString()
        : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (wantKeepAlive) super.build(context);
    refreshWidget();

    return RefreshIndicator(
      onRefresh: () async => refreshWidget(),
      child: RequestLoader(
        request: request,
        completeView: (context, data) {
          if (widget.excludeFilter) {
            if (status != 'Не задано') {
              data = (data ?? [])
                  .where((e) => status == 'Активен'
                      ? e.status.name == status
                      : e.status.name != 'Активен')
                  .toList();
            }
          } else {
            if (status == 'По статусу') {
              data?.sort((a, b) {
                // Если оба элемента активны или оба не активны, сортируем по дате
                if (a.status.name == 'Активен' && b.status.name != 'Активен') {
                  return -1; // "Активен" идет первым
                } else if (a.status.name != 'Активен' &&
                    b.status.name == 'Активен') {
                  return 1; // Остальные статусы идут после "Активен"
                } else {
                  // Если статус одинаковый, сортируем по дате
                  return b.dateReg.compareTo(
                      a.dateReg); // Пример сортировки по убыванию даты
                }
              });
            } else if (status == 'По дате') {
              data?.sort((a, b) {
                return b.dateReg.compareTo(a.dateReg);
              });
            }
          }

          return Column(
            children: [
              if (widget.filterItems.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: DropdownButton<T>(
                      elevation: 1,
                      dropdownColor: NannyTheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                      padding: const EdgeInsets.only(left: 16, bottom: 0),
                      underline: Container(),
                      value: widget.filterItems.firstWhere((e) => e == status),
                      items: widget.filterItems
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  widget.itemLabel(e),
                                  style: const TextStyle(
                                      color: NannyTheme.onSecondary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      height: 1),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          status = value.toString();
                          widget.onItemChanged(value);
                        });
                      }),
                ),
              Expanded(
                child: (data ?? []).isEmpty
                    ? const Center(
                        child: Text("Нет данных..."),
                      )
                    : ListView.separated(
                        padding: widget.padding ??
                            const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 37),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 0,
                          minTileHeight: 0,
                          minVerticalPadding: 0,
                          leading: CircleAvatar(
                            radius: 25,
                            child: ProfileImage(
                                padding: EdgeInsets.zero,
                                url: data![index].photoPath,
                                radius: 50),
                          ),
                          title: Text(
                            "${data[index].name} ${data[index].surname}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: widget.showRequestMoney
                              ? Text(
                                  formatCurrency(
                                      data[index].requestForPayment ?? 0.0),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: NannyTheme.primary),
                                )
                              : Text(
                                  "Статус: ${data[index].jsonData['status'] ?? data[index].status}\n"
                                  "Дата регистрации: ${DateFormat("dd.MM.yyyy").format(
                                  DateTime.parse(data[index].dateReg),
                                )}"),
                          trailing: Theme(
                            data: Theme.of(context)
                                .copyWith(highlightColor: NannyTheme.primary),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: NannyTheme.secondary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0xFF021C3B)
                                          .withOpacity(.1),
                                      offset: const Offset(0, 4),
                                      blurRadius: 11),
                                ],
                              ),
                              child: IconButton(
                                  style: const ButtonStyle(
                                      padding: WidgetStatePropertyAll(
                                          EdgeInsets.zero)),
                                  onPressed: () => widget.onDriverTap(
                                        data![index],
                                      ),
                                  icon: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xFF2D264B),
                                      size: 15),
                                  splashRadius: 20),
                            ),
                          ),
                          onTap: () => widget.onDriverTap(
                            data![index],
                          ),
                        ),
                        separatorBuilder: (context, index) => Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          height: 29,
                          child: const Divider(
                              color: NannyTheme.grey, indent: 1, thickness: 1),
                        ),
                        itemCount: (data ?? []).length,
                      ),
              ),
            ],
          );
        },
        errorView: (context, error) => ErrorView(errorText: error.toString()),
      ),
    );
  }

  late Future<ApiResponse<List<UserInfo<void>>>> request;

  void refreshWidget() => setState(() {
        request = widget.showNewDrivers
            ? NannyFranchiseApi.getNewDrivers()
            : NannyFranchiseApi.getDrivers(
                queryParameters: widget.queryParameters);
      });

  @override
  bool get wantKeepAlive => widget.persistState;

  String formatCurrency(double balance) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    String formatted =
        formatter.format(balance).replaceAll(',', ' ').replaceAll('.', ', ');
    return "$formatted Р";
  }
}
