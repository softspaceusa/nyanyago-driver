import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/reg_vm.dart';

class RegView extends StatefulWidget {
  const RegView({super.key});

  @override
  State<RegView> createState() => _RegViewState();
}

class _RegViewState extends State<RegView> {
  late RegVM vm = RegVM(context: context, update: setState);

  @override
  void initState() {
    super.initState();
    vm.setupNavigator();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NannyAppBar(
          actions: [
            TextButton(
              style: NannyButtonStyles.transparent.copyWith(
                foregroundColor: const MaterialStatePropertyAll(NannyTheme.primary)
              ), 
              onPressed: vm.navigateToLogin,
              child: const Text("Войти"),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Заполнение заявки", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 50),
            Expanded(
              child: NannyBottomSheet(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Navigator(
                      key: vm.navKey,
                      onGenerateRoute: vm.onRouteGen,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}