import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/admin_part/view_models/user_management_vm.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({super.key});

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  late UserManagementVM vm;
  
  List<DropdownMenuData<String>> items = [
    DropdownMenuData(
      title: "Не задано",
      value: ""
    ),
    DropdownMenuData(
      title: "Активен",
      value: "Активен"
    ),
    DropdownMenuData(
      title: "Не активен",
      value: "Не активен"
    ),
  ];

  @override
  void initState() {
    super.initState();
    vm = UserManagementVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NannyAppBar(
          title: "Управление пользователями",
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50), 
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DropdownButton(
                  value: vm.query.statuses.first, 
                  items: items.map(
                    (e) => DropdownMenuItem(
                      value: e.value,
                      child: Text(e.title),
                    )
                  ).toList(), 
                  onChanged: (value) => vm.changeFilter(value!),
                ),
              ),
            ),
          ),
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
              child: RequestLoader(
                request: vm.delayer.request, 
                completeView: (context, data) {
                  if(vm.delayer.isLoading) return const LoadingView();
                  
                  return ListView(
                    shrinkWrap: true,
                    children: data!.users.map(
                      (e) => e.id == -1 ? const SizedBox() : Slidable(
                        endActionPane: ActionPane(
                          extentRatio: .8,
                          motion: const DrawerMotion(), 
                          children: [
                            SlidableAction(
                              flex: 2,
                              onPressed: (context) => vm.banUser(e),
                              backgroundColor: NannyTheme.darkGrey,
                              icon: e.status == UserStatus.active ? Icons.no_accounts : Icons.account_circle,
                              label: e.status == UserStatus.active ? "Заблокировать" : "Разблокировать",
                            ),
                            SlidableAction(
                              flex: 1,
                              onPressed: (context) => vm.deleteUser(e),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: "Удалить",
                            ),
                          ]
                        ),
                        child: ListTile(
                          leading: ProfileImage(
                            url: e.photoPath, 
                            radius: 50
                          ),
                          title: Text("${e.name} ${e.surname}", softWrap: true),
                          subtitle: Text(vm.phoneMask.maskText(e.phone.substring(1))),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text( 
                                  e.role.map((e) => e.name).join(',\n'), 
                                  style: Theme.of(context).textTheme.labelMedium,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Text(e.dateReg),
                            ],
                          ),
                          tileColor: e.status != UserStatus.active ? Colors.redAccent[100] : null,
                        ),
                      ),
                    ).toList(),
                  );
                },
                errorView: (context, error) => ErrorView(errorText: error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}