import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/from_api/my_referals_data.dart';
import 'package:nanny_core/models/from_api/roles/referal_data.dart';
import 'package:nanny_core/models/from_api/user_info.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/franchise/view_models/partner/my_referals_vm.dart';
import 'package:nanny_components/widgets/states/info_view.dart';

class MyReferalsView extends StatefulWidget {
  const MyReferalsView({super.key});

  @override
  State<MyReferalsView> createState() => _MyReferalsViewState();
}

class _MyReferalsViewState extends State<MyReferalsView> {
  late MyReferalsVM vm;

  @override
  void initState() {
    super.initState();
    vm = MyReferalsVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const NannyAppBar(
        isTransparent: false,
        color: NannyTheme.secondary,
        title: "Рефералы",
      ),
      body: RequestLoader(
        request: vm.request,
        completeView: (context, data) {
          //MyReferalData? data = MyReferalData(
          //  allIncoming: 500,
          //  getPercent: 205.137,
          //  referrals: List.generate(
          //    10,
          //    (index) => UserInfo(
          //      surname: '123',
          //      name: '123',
          //      phone: '1231231231231',
          //      role: [UserType.admin],
          //      photoPath: '',
          //      videoPath: '',
          //      roleData: Referral(allIncoming: 5, getPercent: 5),
          //    ),
          //  ),
          //);
          return Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: textInfo(
                          title: "Общий баланс:",
                          subtitle: vm.formatCurrency(
                            data!.allIncoming.toDouble(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textInfo(
                          title: "Вы получите:",
                          subtitle: vm.formatCurrency(data.getPercent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: data.referrals.isEmpty
                        ? const InfoView(infoText: "Ещё нет данных")
                        : ListView.separated(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 24),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              UserInfo<Referral> referral =
                                  data.referrals[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                minLeadingWidth: 0,
                                minTileHeight: 0,
                                minVerticalPadding: 0,
                                isThreeLine: true,
                                leading: ProfileImage(
                                    url: referral.photoPath,
                                    radius: 50,
                                    padding: EdgeInsets.zero),
                                title: Text(
                                  "${referral.name} ${referral.surname}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Присоединился ${referral.dateReg}",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            height: 14.4 / 12,
                                            color: NannyTheme.darkGrey),
                                      ),
                                      const SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Всего заработано ",
                                              style: TextStyle(
                                                  color: NannyTheme.primary),
                                            ),
                                            TextSpan(
                                                text: vm.formatCurrency(
                                                  referral.roleData!.allIncoming
                                                      .toDouble(),
                                                ),
                                                style: const TextStyle(
                                                    color: NannyTheme
                                                        .onSecondary)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                                text:
                                                    "Вы получите (% от суммы) ",
                                                style: TextStyle(
                                                    color: NannyTheme.primary)),
                                            TextSpan(
                                              text: vm.formatCurrency(referral
                                                  .roleData!.getPercent),
                                              style: const TextStyle(
                                                  color:
                                                      NannyTheme.onSecondary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 25,
                              child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: NannyTheme.grey),
                            ),
                            itemCount: data.referrals.length,
                          ),
                  ),
                ],
              ),
              //Align(
              //  alignment: Alignment.bottomCenter,
              //  child: Padding(
              //    padding: const EdgeInsets.only(bottom: 10),
              //    child: ElevatedButton(
              //        onPressed: () => vm.navigateToView(const WalletView(
              //            title: "Отправить запрос",
              //            subtitle: "Выберите карту")),
              //        child: const Text("Отправить запрос")),
              //  ),
              //),
            ],
          );
        },
        errorView: (context, error) => ErrorView(errorText: error.toString()),
      ),
    );
  }

  Widget textInfo({
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        Text(subtitle, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}
