import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/globals.dart';
import 'package:nanny_driver/view_models/reg_pages/reg_success_vm.dart';

class RegSuccessView extends StatefulWidget {
  const RegSuccessView({super.key});

  @override
  State<RegSuccessView> createState() => _RegSuccessViewState();
}

class _RegSuccessViewState extends State<RegSuccessView> {
  String driverName = NannyDriverGlobals.driverRegForm.userData.name;
  late RegSuccessVM vm;

  @override
  void initState() {
    super.initState();
    vm = RegSuccessVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureLoader(
            future: vm.tryRegDriver(),
            completeView: (context, data) {
              if(!data) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const ErrorView(
                          errorText: "Не удалось зарегистрироваться!"
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: vm.tryAgain,
                          child: const Text("Попробовать снова"),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                
                    ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [NannyTheme.background, Colors.transparent],
                        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset('packages/nanny_components/assets/images/ok.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "$driverName, Вы успешно зарегистрировались", 
                      style: Theme.of(context).textTheme.titleLarge, 
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Информация передана куратору и ваша заявка будет расмотрена в течение 24 часов", 
                      textAlign: TextAlign.center,
                    ),
                    
                  ],
                ),
              );
            },
            errorView: (context, error) => ErrorView(errorText: error.toString()),
          ),
        ),
      ),
    );
  }
}