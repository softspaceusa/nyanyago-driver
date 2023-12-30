import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/reg_vm.dart';
import 'package:nanny_driver/views/reg_pages.dart/step_one.dart';

class RegView extends StatefulWidget {
  const RegView({super.key});

  @override
  State<RegView> createState() => _RegViewState();
}

class _RegViewState extends State<RegView> {
  late RegVM vm = RegVM(context: context, update: setState);
  GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  bool inited = false;

  @override
  void initState() {
    super.initState();
    navKey.currentState?.push(
      MaterialPageRoute(builder: (context) => const RegStepOneView())
    );
  }

  Route<dynamic>? onRouteGen(RouteSettings settings) {
    if(!inited) return MaterialPageRoute(builder: (context) => const RegStepOneView());

    return null;
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
                  padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  child: Navigator(
                    key: navKey,
                    onGenerateRoute: onRouteGen,
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