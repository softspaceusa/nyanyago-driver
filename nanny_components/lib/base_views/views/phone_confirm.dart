import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/view_models/phone_confirm_vm.dart';
import 'package:nanny_components/nanny_components.dart';

class PhoneConfirmView extends StatefulWidget {
  final Widget nextScreen;
  final String title;
  final String text;
  final bool isReg;
  
  const PhoneConfirmView({
    super.key,
    required this.nextScreen,
    required this.title,
    required this.text,
    required this.isReg,
  });

  @override
  State<PhoneConfirmView> createState() => _PhoneConfirmViewState();
}

late PhoneConfirmVM _vm;
class _PhoneConfirmViewState extends State<PhoneConfirmView> {

  @override
  void initState() {
    super.initState();
    _vm = PhoneConfirmVM(
      baseContext: context,
      context: context, 
      update: setState, 
      nextScreen: widget.nextScreen,
      title: widget.title,
      text: widget.text,
      isReg: widget.isReg,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(),
        extendBodyBehindAppBar: _vm.extendBehindAppBar,
        resizeToAvoidBottomInset: false,
        body: _vm.currentView,
      ),
    );
  }
}

class PhoneEnterView extends StatelessWidget {
  final String title;
  final String text;

  const PhoneEnterView({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            Text(text, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 50),
            Form(
              key: _vm.phoneState,
              child: NannyTextForm(
                labelText: "Номер телефона*",
                hintText: "+7 (777) 777-77-77",
                keyType: TextInputType.number,
                formatters: [_vm.phoneMask],
                validator: (text) {
                  if(_vm.phone.length < 11) return "Введите номер телефона!";
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _vm.toPhoneConfirmation, 
              child: const Text("Отправить код подтверждения")
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneEnterConfirmView extends StatefulWidget {

  const PhoneEnterConfirmView({super.key});

  @override
  State<PhoneEnterConfirmView> createState() => _PhoneEnterConfirmViewState();
}

class _PhoneEnterConfirmViewState extends State<PhoneEnterConfirmView> {

  @override
  void initState() {
    super.initState();
    _vm.update = setState;
    _vm.initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 50, right: 20, bottom: 20),
            child: Text("Мы отправили вам СМС код", textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall),
          ),
          Expanded(
            child: FourDigitKeyboard(
              topChild: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    const TextSpan(text: "На номер: "),
                    TextSpan(text: _vm.phoneMask.getMaskedText(), style: const TextStyle(color: NannyTheme.primary)),
                  ],
                ),
              ),
              bottomChild: _vm.timerEnded ? TextButton(
                onPressed: _vm.resendSms, 
                child: const Text("Отправить СМС заново")
              ) : SmsTimer(
                secFrom: _vm.timeLeft, 
                onEnd: _vm.onTimerEnd
              ),
              onCodeChanged: (code) {
                _vm.code = code;
                if(code.length > 3) _vm.checkPhone();
              },
            ),
          ),
        ],
      ),
    );
  }
}