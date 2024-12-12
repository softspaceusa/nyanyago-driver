import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/admin_part/view_models/referal_info_vm.dart';
import 'package:nanny_components/nanny_components.dart';

class ReferalInfoView extends StatefulWidget {
  final int referalId;

  const ReferalInfoView({
    super.key,
    required this.referalId,
  });

  @override
  State<ReferalInfoView> createState() => _ReferalInfoViewState();
}

class _ReferalInfoViewState extends State<ReferalInfoView> {
  late final ReferalInfoVM vm;

  @override
  void initState() {
    super.initState();
    vm = ReferalInfoVM(
        context: context, update: setState, referalId: widget.referalId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: const NannyAppBar(
        title: "Партнер",
      ),
      body: RequestLoader(
        request: vm.request,
        completeView: (context, data) => AdaptBuilder(builder: (context, size) {
          if (data == null) {
            return const ErrorView(errorText: "Реферал не является водителем");
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    ProfileImage(
                        url: data.photoPath, radius: size.shortestSide * .3),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 5,
                            children: [
                              Text(
                                data.name,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                data.surname,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          Text(
                            TextMasks.phoneMask().maskText(data.phone),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                NannyTextForm(
                  labelText: "% кешбека",
                  readOnly: true,
                  initialValue: data.roleData!.referalPercent.toString(),
                  hintText: data.roleData!.referalPercent.toString(),
                ),
                const SizedBox(height: 20),
                NannyTextForm(
                  labelText: "Дата перехода по ссылке партнера",
                  readOnly: true,
                  initialValue: data.dateReg,
                  hintText: data.dateReg,
                ),
              ],
            ),
          );
        }),
        errorView: (context, error) => ErrorView(errorText: error.toString()),
      ),
    ));
  }
}
