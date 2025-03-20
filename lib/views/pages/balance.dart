import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/view_models/pages/balance_vm.dart';

class BalanceView extends StatefulWidget {
  final bool persistState;

  const BalanceView({
    super.key,
    required this.persistState,
  });

  @override
  State<BalanceView> createState() => _BalanceViewState();
}

class _BalanceViewState extends State<BalanceView>
    with AutomaticKeepAliveClientMixin {
  late BalanceVM vm;

  @override
  void initState() {
    super.initState();
    vm = BalanceVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    if (wantKeepAlive) super.build(context);

    return SafeArea(child: AdaptBuilder(builder: (context, size) {
      return Scaffold(
        appBar: const NannyAppBar(
          hasBackButton: false,
          isTransparent: false,
          title: "Баланс ",
        ),
        body: RequestLoader(
          request: vm.getMoney,
          completeView: (context, data) => RefreshIndicator(
            onRefresh: () async => vm.updateState(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  ListView(
                    children: [
                      const SizedBox(height: 20),
                      const Text("Текущий баланс:",
                          textAlign: TextAlign.center),
                      Text(NannyUtils.formatCurrency(data?.balance ?? 0),
                          style: const TextStyle(
                              fontFamily: '',
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      const Text('Выберите карту для  вывода денежных средств',
                          style: TextStyle(
                              color: Color(0xFF2B2B2B),
                              fontFamily: 'Nunito',
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 23),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => vm.changeSwitchType(
                                  isCashbackButtonSelected: false),
                              style: vm.isCashbackButtonSelected
                                  ? NannyButtonStyles.secondary.copyWith(
                                      minimumSize: const WidgetStatePropertyAll(
                                        Size(double.infinity, 50),
                                      ),
                                    )
                                  : NannyButtonStyles.main.copyWith(
                                      minimumSize: const WidgetStatePropertyAll(
                                        Size(double.infinity, 50),
                                      ),
                                    ),
                              child: const Text("Получение ЗП"),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => vm.changeSwitchType(
                                  isCashbackButtonSelected: true),
                              style: vm.isCashbackButtonSelected
                                  ? NannyButtonStyles.main.copyWith(
                                      minimumSize: const WidgetStatePropertyAll(
                                        Size(double.infinity, 50),
                                      ),
                                    )
                                  : NannyButtonStyles.secondary.copyWith(
                                      minimumSize: const WidgetStatePropertyAll(
                                        Size(double.infinity, 50),
                                      ),
                                    ),
                              child: const Text("% кэшбэк"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 27),
                      RequestLoader(
                        request: vm.cardRequest,
                        completeView: (context, data) => ListView.separated(
                            padding: const EdgeInsets.only(bottom: 30),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (index == data.cards.length) {
                                return DebitCardWidget(
                                    size: size,
                                    isAddCardWidget: true,
                                    onAddCard: () => vm.navigateToAddCard());
                              }
                              final card = data.cards[index];
                              return DebitCardWidget(
                                  card: card,
                                  size: size,
                                  isSelected: vm.selectedId == card.id,
                                  onTap: vm.selectCard,
                                  onLongTap: vm.deleteCard);
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 17),
                            itemCount: data!.cards.length + 1),
                        errorView: (context, error) =>
                            ErrorView(errorText: error.toString()),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: ElevatedButton(
                      onPressed: vm.selectedId != null
                          ? () => vm.changeSwitchType(
                              isCashbackButtonSelected: false)
                          : null,
                      style: NannyButtonStyles.main.copyWith(
                        minimumSize: const WidgetStatePropertyAll(
                          Size(double.infinity, 50),
                        ),
                      ),
                      child: Text(vm.isCashbackButtonSelected
                          ? "Запросить"
                          : "Отправить"),
                    ),
                  )
                ],
              ),
            ),
          ),
          errorView: (context, error) => ErrorView(errorText: error.toString()),
        ),
      );
    }));
  }

  @override
  bool get wantKeepAlive => widget.persistState;
}
