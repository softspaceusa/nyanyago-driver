import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/models/active_contracts.dart';

class ActiveContractsVM extends ViewModelBase {
  ActiveContractsVM({
    required super.context,
    required super.update,
  });

  List<ActiveContractsModel> contracts = [];

  @override
  Future<bool> get loadRequest =>
      Future<bool>.delayed(const Duration(seconds: 1), () async {
        contracts.clear();
        contracts.addAll([
          ActiveContractsModel(
              type: 'Недельный',
              title: '',
              actions: ['Посидеть с ребенком', 'Помочь переодеться'],
              price: 1251,
              wholePrice: 12334,
              childrenCount: 2,
              schedules: [
                DateTime.now().copyWith(day: 10, hour: 12, minute: 15),
                DateTime.now().copyWith(day: 11, hour: 16, minute: 30),
                DateTime.now().copyWith(day: 13, hour: 11, minute: 0)
              ],
              name: 'Анастасия',
              avatar: ''),
          ActiveContractsModel(
              type: 'Недельный',
              title: '',
              actions: ['Посидеть с ребенком', 'Помочь переодеться'],
              price: 1091,
              wholePrice: 10261,
              childrenCount: 1,
              name: 'Мария',
              schedules: [
                DateTime.now().copyWith(day: 1, hour: 11, minute: 30),
                DateTime.now().copyWith(day: 14, hour: 14, minute: 0),
                DateTime.now().copyWith(day: 15, hour: 18, minute: 45)
              ],
              avatar: ''),
        ]);
        return false;
      });
}
