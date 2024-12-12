import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/admin_part/view_models/referral_program_vm.dart';
import 'package:nanny_components/nanny_components.dart';

class ReferralProgramView extends StatefulWidget {
  const ReferralProgramView({super.key});

  @override
  State<ReferralProgramView> createState() => _ReferralProgramViewState();
}

class _ReferralProgramViewState extends State<ReferralProgramView> {
  late ReferralProgramVm vm;

  @override
  void initState() {
    super.initState();
    vm = ReferralProgramVm(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Реферальная программа",
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: NannyTextForm(
                style: NannyTextFormStyles.searchForm,
                hintText: "Поиск",
                onChanged: (text) => vm.search(text),
              ),
            ),
            Expanded(
              child: RequestListLoader(
                shrinkWrap: true,
                request: vm.delayer.request,
                tileTemplate: (context, e) => ListTile(
                  onTap: () => vm.navigateToPartner(e.id),
                  leading: ProfileImage(url: e.photoPath, radius: 50),
                  title: Text("${e.name} ${e.surname}", softWrap: true),
                  trailing: Text(e.dateReg),
                ),
                errorView: (context, error) =>
                    ErrorView(errorText: error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
