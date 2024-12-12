import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanny_components/base_views/admin_part/view_models/partner_info_vm.dart';
import 'package:nanny_components/base_views/admin_part/views/referal_info.dart';
import 'package:nanny_components/nanny_components.dart';

class PartnerInfoView extends StatefulWidget {
  final int partnerId;

  const PartnerInfoView({
    super.key,
    required this.partnerId,
  });

  @override
  State<PartnerInfoView> createState() => _PartnerInfoViewState();
}

class _PartnerInfoViewState extends State<PartnerInfoView> {
  late PartnerInfoVM vm;

  @override
  void initState() {
    super.initState();
    vm = PartnerInfoVM(
        context: context, update: setState, partnerId: widget.partnerId);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Доделать
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Партнер",
        ),
        body: RequestLoader(
          request: vm.request,
          completeView: (context, data) =>
              AdaptBuilder(builder: (context, size) {
            if (data == null)
              return const ErrorView(
                  errorText: "Партнер не состоит ни в одной франшизе");

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
                    labelText: "Реферальная ссылка",
                    initialValue: data.roleData!.referalCode,
                    readOnly: true,
                    style: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () =>
                            vm.copyCode(data.roleData!.referalCode),
                        icon: const Icon(Icons.copy),
                        splashRadius: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  NannyTextForm(
                    labelText: "% кешбека",
                    initialValue: data.roleData!.referalPercent.toString(),
                    hintText: data.roleData!.referalPercent.toString(),
                    keyType: TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                    readOnly: true,
                    //style: InputDecoration(
                    //  suffixIcon: Padding(
                    //    padding: const EdgeInsets.all(5),
                    //    child: SizedBox(
                    //      width: 60,
                    //      child: ElevatedButton(
                    //        onPressed: vm.savePercent,
                    //        child: const Icon(Icons.save)
                    //      ),
                    //    ),
                    //  ),
                    //),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () => vm.listSwitch(true),
                            style: vm.showReferals
                                ? null
                                : NannyButtonStyles.whiteButton,
                            child: const Text("Рефералы")),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () => vm.listSwitch(false),
                            style: vm.showReferals
                                ? NannyButtonStyles.whiteButton
                                : null,
                            child: const Text("Заявки")),
                      ),
                    ],
                  ),
                  Expanded(
                    child: vm.showReferals
                        ? ListView(
                            shrinkWrap: true,
                            children: data.roleData!.referals
                                .map((e) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text("${e.name} ${e.surname}"),
                                          trailing: Text(e.dateReg),
                                          onTap: () => vm.navigateToView(
                                              ReferalInfoView(referalId: e.id)),
                                        ),
                                        const Divider(
                                            color: NannyTheme.darkGrey)
                                      ],
                                    ))
                                .toList(),
                          )
                        : ListView(
                            shrinkWrap: true,
                            children: const [], // TODO: API!!!
                          ),
                  ),
                ],
              ),
            );
          }),
          errorView: (context, error) => ErrorView(errorText: error.toString()),
        ),
      ),
    );
  }
}
