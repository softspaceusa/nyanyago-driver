import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_core/models/from_api/other_parametr.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsWidget extends StatefulWidget {
  const DetailsWidget({
    required this.addresses,
    required this.params,
    required this.selectedParams,
    required this.selectedDriverType,
    required this.amount,
    required this.selectedTariff,
    required this.onParamsChanged,
    this.canEdit = false,
    this.duration,
    super.key,
  });

  final List<String> addresses;
  final List<OtherParametr> params;
  final Set<int> selectedParams;
  final int selectedDriverType;
  final double amount;
  final DriveTariff selectedTariff;
  final Function(Map<String, dynamic> params) onParamsChanged;
  final bool canEdit;
  final int? duration;

  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  // Переменные для хранения выбранных данных
  late int _selectedDriverType;

  @override
  void initState() {
    _selectedDriverType = widget.selectedDriverType;
    super.initState();
  }

  // Обработчик для изменения выбранных параметров
  void _onParamChanged(bool? selected, int paramId) {
    setState(() {
      if (selected == true) {
        widget.selectedParams.add(paramId);
      } else {
        widget.selectedParams.remove(paramId);
      }
    });
  }

  // Обработчик для изменения типа водителя
  void _onDriverTypeChanged(int? value) {
    setState(() {
      _selectedDriverType = value ?? _selectedDriverType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: ListView(
        children: [
          addressesWidget(),
          const SizedBox(height: 24),
          tariffInfo(),
          const SizedBox(height: 16),
          driverTypeSelector(),
          const SizedBox(height: 24),
          paramSelector(),
          const SizedBox(height: 68),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(
                child: ElevatedButton(
                  style: NannyButtonStyles.main,
                  onPressed: () async {
                    if (!widget.canEdit) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('socket_token');
                      widget.onParamsChanged({'cancelOrder': true});
                    } else {
                      widget.onParamsChanged({
                        'selectedDriverType': _selectedDriverType,
                        'selectedParams': widget.selectedParams
                      });
                    }

                    Navigator.of(context).pop(true);
                  },
                  child: Text(!widget.canEdit ? 'Отменить заказ' : 'Применить'),
                ),
              )
            ]),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Виджет для выбора типа водителя через радио кнопки
  Widget driverTypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: widget.canEdit
          ? ExpansionTile(
              expandedAlignment: Alignment.centerLeft,
              shape: const Border(),
              title: Text('Тип поездки:', style: NannyTextStyles.nw40018),
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: DriveType.values.map((DriveType value) {
                    return Column(
                      children: [
                        RadioListTile<int>(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              value.name,
                              style: const TextStyle(
                                  color: Color(0xFF212121),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 17.6 / 16),
                            ),
                            value: value.id,
                            groupValue: _selectedDriverType,
                            activeColor: NannyTheme.primary,
                            onChanged: _onDriverTypeChanged),
                        const Divider(color: NannyTheme.grey, height: 1),
                      ],
                    );
                  }).toList(),
                )
              ],
            )
          : Text(
              "Тип поездки: ${DriveType.values.firstWhere((e) => e.id == widget.selectedDriverType).name}",
              style: NannyTextStyles.nw40018),
    );
  }

  // Виджет для отображения адресов
  Widget addressesWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          _addressRow(widget.addresses.first, 'map_marker_user.png'),
          const SizedBox(height: 8),
          _addressRow(widget.addresses.last, 'map_marker_loc.png'),
        ],
      ),
    );
  }

  // Помощник для создания строки с адресом
  Widget _addressRow(String address, String imagePath) {
    return Row(
      children: [
        Image.asset('packages/nanny_components/assets/images/map/$imagePath',
            height: 24, width: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            address,
            maxLines: null,
            style: NannyTextStyles.nw40018,
          ),
        ),
      ],
    );
  }

  // Виджет для списка дополнительных параметров с чекбоксами
  Widget paramSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ExpansionTile(
        shape: const Border(),
        tilePadding: EdgeInsets.zero,
        title:
            Text('Дополнительные параметры:', style: NannyTextStyles.nw40018),
        children: [
          ...widget.params
              .where((e) =>
                  widget.canEdit ? true : widget.selectedParams.contains(e.id))
              .map((param) {
            return Column(
              children: [
                CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    shape: NannyTheme.roundBorder,
                    title: Text(
                      "${param.title} - ${param.amount} Р",
                      style: const TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 17.6 / 16),
                    ),
                    value: widget.selectedParams.contains(param.id),
                    activeColor: NannyTheme.primary,
                    onChanged: widget.canEdit
                        ? (bool? selected) {
                            _onParamChanged(selected, param.id!);
                          }
                        : null),
                const Divider(color: NannyTheme.grey, height: 1),
              ],
            );
          }).toList()
        ],
      ),
    );
  }

  // Виджет с информацией о тарифе
  Widget tariffInfo() {
    var img = widget.selectedTariff.photoPath;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      height: 160,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 4,
            child: img != null
                ? SizedBox(
                    width: 164,
                    height: 103,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: NetImage(url: img, radius: 0, fit: BoxFit.cover),
                    ),
                  )
                : placeholderImg(),
          ),
          Positioned(
            top: 16,
            right: 14,
            child: Text(
              '${widget.amount.toStringAsFixed(1)} Р',
              style: NannyTextStyles.nw40018.copyWith(fontSize: 30),
            ),
          ),
          if (widget.duration != null)
            Positioned(
              top: 54,
              right: 24,
              child: Text(
                '${widget.duration} мин',
                style: NannyTextStyles.nw60024.copyWith(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  // Заполнитель для изображения тарифа
  Widget placeholderImg() => Image.asset(
        'packages/nanny_components/assets/images/car.png',
        height: 100,
        width: 164,
      );

  // Форматирование валюты
  String formatCurrency(double balance) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    String formatted =
        formatter.format(balance).replaceAll(',', ' ').replaceAll('.', ', ');
    return "$formatted Р";
  }
}

class Reorderable {
  static DriveTariff? currentTariff;
  static double orderDuration = 0;
}
