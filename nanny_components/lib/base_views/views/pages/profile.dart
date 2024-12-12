import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanny_components/base_views/view_models/pages/profile_vm.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class ProfileView extends StatefulWidget {
  final Widget logoutView;
  final bool persistState;

  const ProfileView({
    super.key,
    required this.logoutView,
    this.persistState = false,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  late ProfileVM vm;

  @override
  void initState() {
    super.initState();
    vm = ProfileVM(
        context: context, update: setState, logoutView: widget.logoutView);

    vm.firstName = NannyUser.userInfo!.name;
    vm.lastName = NannyUser.userInfo!.surname;
  }

  @override
  Widget build(BuildContext context) {
    if (wantKeepAlive) super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: NannyAppBar(
        title: "Профиль",
        isTransparent: false,
        hasBackButton: false,
        color: NannyTheme.secondary,
        leading: IconButton(
          onPressed: vm.navigateToAppSettings,
          icon: const Icon(Icons.settings),
          splashRadius: 30,
        ),
        actions: [
          IconButton(
            onPressed: vm.logout,
            icon: const Icon(Icons.exit_to_app_rounded),
            splashRadius: 30,
          )
        ],
      ),
      body: AdaptBuilder(builder: (context, size) {
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    ProfileImage(
                      url: NannyUser.userInfo!.photoPath,
                      radius: size.shortestSide * .3,
                      onTap: vm.changeProfilePhoto,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 5,
                            children: [
                              Text(
                                NannyUser.userInfo!.name,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                NannyUser.userInfo!.surname,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          Text(
                            TextMasks.phoneMask().maskText(
                                NannyUser.userInfo!.phone.substring(1)),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: NannyBottomSheet(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          NannyTextForm(
                            labelText: "Имя",
                            initialValue: vm.firstName,
                            onChanged: (text) => vm.firstName = text.trim(),
                            isExpanded: true,
                            formatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Zа-яА-ЯёЁ]'),
                              )
                            ],
                            suffixIcon: SvgPicture.asset(
                                'packages/nanny_components/assets/images/pencil.svg',
                                height: 21,
                                width: 21),
                          ),
                          const SizedBox(height: 20),
                          NannyTextForm(
                            labelText: "Фамилия",
                            initialValue: vm.lastName,
                            onChanged: (text) => vm.lastName = text.trim(),
                            isExpanded: true,
                            formatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Zа-яА-ЯёЁ]'),
                              )
                            ],
                            suffixIcon: SvgPicture.asset(
                                'packages/nanny_components/assets/images/pencil.svg',
                                height: 21,
                                width: 21),
                          ),
                          const SizedBox(height: 20),
                          NannyTextForm(
                            readOnly: true,
                            labelText: "Пароль",
                            initialValue: "••••••••",
                            onTap: vm.changePassword,
                            isExpanded: true,
                            suffixIcon: SvgPicture.asset(
                                'packages/nanny_components/assets/images/pencil.svg',
                                height: 21,
                                width: 21),
                          ),
                          const SizedBox(height: 20),
                          NannyTextForm(
                            readOnly: true,
                            labelText: "Пин-код",
                            initialValue: "••••",
                            onTap: vm.changePincode,
                            isExpanded: true,
                            suffixIcon: SvgPicture.asset(
                                'packages/nanny_components/assets/images/pencil.svg',
                                height: 21,
                                width: 21),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: vm.saveChanges,
                            child: const Text("Сохранить"),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => widget.persistState;
}
