import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/api_models/get_users_request.dart';
import 'package:nanny_core/nanny_core.dart';

class UserManagementVM extends ViewModelBase {
  UserManagementVM({
    required super.context, 
    required super.update
  }) {
    delayer = SearchDelayer<GetUsersData>(
      delay: const Duration(seconds: 1),
      initRequest: NannyAdminApi.getUsers( GetUsersRequest() ),
      update: () => update(() {}),
    );
  }

  GetUsersRequest query = GetUsersRequest(statuses: [""]);
  late final SearchDelayer<GetUsersData> delayer;
  final MaskTextInputFormatter phoneMask = TextMasks.phoneMask();

  void resendRequestWithDelay() => delayer.wait(
    onCompleteRequest: NannyAdminApi.getUsers(query),
  );

  void resendRequest() => delayer.updateRequest(NannyAdminApi.getUsers(query));

  void changeFilter(String value) {
    query = query.copyWith(
      statuses: [value],
    );
    resendRequest();
  }

  void search(String text) {
    query = query.copyWith(
      search: text,
    );
    resendRequestWithDelay();
  }

  void banUser(UserInfo user) async {
    if(!await NannyDialogs.confirmAction(context, "${user.status == UserStatus.active ? "Заблокировать" : "Разблокировать"} ${user.name}?")) return;
    if(!context.mounted) return;
    
    LoadScreen.showLoad(context, true);

    bool success = await DioRequest.handleRequest(
      context, 
      NannyAdminApi.banUser(user.id),
    );

    if(!success) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, false);
    resendRequest();
  }

  void deleteUser(UserInfo user) async {
    if(!await NannyDialogs.confirmAction(context, "Удалить ${user.name}?")) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, true);

    bool success = await DioRequest.handleRequest(
      context, 
      NannyAdminApi.deleteUser(user.id),
    );

    if(!success) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, false);
    resendRequest();
  }
}