import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/view_models/pages/chats_vm.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class ChatsView extends StatefulWidget {
  final bool persistState;

  const ChatsView({
    super.key,
    this.persistState = false,
  });

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView>
    with AutomaticKeepAliveClientMixin {
  late ChatsVM vm;

  @override
  void initState() {
    super.initState();
    vm = ChatsVM(context: context, update: setState);
  }

  @override
  void dispose() {
    super.dispose();
    vm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (wantKeepAlive) super.build(context);

    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Чаты",
          isTransparent: false,
          hasBackButton: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                NannyTextForm(
                  style: NannyTextFormStyles.searchForm,
                  onChanged: vm.chatSearch,
                ),
                const SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => vm.chatsSwitch(switchToChats: false),
                          style: vm.chatsSelected
                              ? NannyButtonStyles.whiteButton
                              : null,
                          child: const Text("Заявки"),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () =>
                                  vm.chatsSwitch(switchToChats: true),
                              style: vm.chatsSelected
                                  ? null
                                  : NannyButtonStyles.whiteButton,
                              child: const Text("Чаты")))
                    ]),
                const SizedBox(height: 20),
                Expanded(
                  child: StatefulBuilder(builder: (context, update) {
                    vm.updateList = () => update(() {});

                    return vm.chatsSelected
                        ? RequestLoader(
                            request: vm.getChats,
                            completeView: (context, data) {
                              if (data == null) {
                                return const Center(
                                  child: Text("У вас пока что нет чатов..."),
                                );
                              }

                              return ListView(
                                  children: data.chats
                                      .map((e) => ListTile(
                                            leading: ProfileImage(
                                                url: e.photoPath, radius: 50),
                                            title: Text(e.username),
                                            subtitle: Text(e.message == null
                                                ? "Нет сообщений"
                                                : e.message!.msg),
                                            trailing: Column(children: [
                                              if (e.message != null &&
                                                  e.message!.newMessages > 0)
                                                CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor:
                                                      NannyTheme.primary,
                                                  foregroundColor:
                                                      NannyTheme.onPrimary,
                                                  child: Text(
                                                      e.message!.newMessages
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              Flexible(
                                                  child: Text(e.message != null
                                                      ? DateFormat("HH:mm")
                                                          .format(DateTime
                                                              .fromMillisecondsSinceEpoch(e
                                                                      .message!
                                                                      .time *
                                                                  1000))
                                                      : ""))
                                            ]),
                                            onTap: () => vm.navigateToDirect(e),
                                          ))
                                      .toList());
                            },
                            errorView: (context, error) =>
                                ErrorView(errorText: error.toString()),
                          )
                        : RequestLoader(
                            request: vm.getRequests,
                            completeView: (context, data) => ListView(
                              children: data!
                                  .map((e) => Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: ListTile(
                                            leading: ProfileImage(
                                                url: e.photoPath, radius: 60),
                                            title: Text(e.name),
                                            subtitle: Text(e.schedule!.title),
                                            onTap: () =>
                                                vm.checkScheduleRequest(e),
                                            shape: NannyTheme.roundBorder,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            errorView: (context, error) =>
                                ErrorView(errorText: error.toString()),
                          );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.persistState;
}
