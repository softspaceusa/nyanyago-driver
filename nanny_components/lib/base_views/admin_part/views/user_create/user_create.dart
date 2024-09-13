import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/admin_part/view_models/user_create/user_create_vm.dart';
import 'package:nanny_components/nanny_components.dart';

class UserCreateView extends StatefulWidget {
  const UserCreateView({super.key});

  @override
  State<UserCreateView> createState() => _UserCreateViewState();
}

class _UserCreateViewState extends State<UserCreateView> {
  late UserCreateVM vm;
  
  @override
  void initState() {
    super.initState();
    vm = UserCreateVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Создание пользователя",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                createButton(
                  name: "Франшиза", 
                  photoPath: "franchise_create.png",
                  onTap: vm.toFranchiseCreate,
                ),
                const SizedBox(height: 10),
                createButton(
                  name: "Партнер", 
                  photoPath: "partner_create.png",
                  onTap: vm.toPartnerCreate,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createButton({
    required String name,
    required String photoPath,
    required VoidCallback onTap
  }) {
    return ElevatedButton(
      style: NannyButtonStyles.whiteButton,
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name),
          Image.asset('packages/nanny_components/assets/images/$photoPath')
        ],
      )
    );
  }
}