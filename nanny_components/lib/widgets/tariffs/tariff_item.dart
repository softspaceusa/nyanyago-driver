import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/styles/nanny_theme.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_core/nanny_core.dart';

class TariffItem extends StatelessWidget {
  const TariffItem(
      {super.key,
      required this.pageController,
      required this.tariffs,
      required this.isOneTimeTrips});

  final PageController pageController;
  final List<DriveTariff> tariffs;
  final bool isOneTimeTrips;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 250,
          padding: const EdgeInsets.only(top: 16, bottom: 43),
          decoration: BoxDecoration(
            color: NannyTheme.secondary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 32,
                color: NannyTheme.shadow.withOpacity(.1),
              ),
            ],
          ),
          child: PageView.builder(
            controller: pageController,
            itemBuilder: (context, index) {
              DriveTariff tariff = tariffs[index];

              return FractionallySizedBox(
                widthFactor: 1 / pageController.viewportFraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Text(
                        isOneTimeTrips
                            ? 'Разовая поездка'
                            : 'Ежедневные поездки',
                        style: const TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Левый блок
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 168,
                                padding: const EdgeInsets.only(left: 14),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(tariff.type ?? 'N/A',
                                      style: const TextStyle(
                                          color: NannyTheme.primary,
                                          fontSize: 34,
                                          height: 46.38 / 34,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Spacer(),
                              Image.asset(
                                  width: 168,
                                  'packages/nanny_components/assets/images/car.png'),
                            ],
                          ),
                          // Правый блок
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Верхняя часть
                                Text(
                                  formatCurrency(tariff.amount ?? 0),
                                  style: const TextStyle(
                                      color: Color(0xFF2B2B2B),
                                      fontSize: 30,
                                      height: 40.92 / 30,
                                      fontWeight: FontWeight.w400),
                                ),
                                const Text(
                                  '1 мин',
                                  style: TextStyle(
                                      color: Color(0xFF2B2B2B),
                                      fontSize: 16,
                                      height: 24 / 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 28),

                                const Text(
                                  'Название маршрута:',
                                  style: TextStyle(
                                      color: Color(0xFF1B1B1B),
                                      fontSize: 16,
                                      height: 23 / 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  tariff.title ?? 'Название не указано',
                                  style: const TextStyle(
                                      color: NannyTheme.onSecondary,
                                      fontSize: 12,
                                      height: 16.8 / 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: tariffs.length,
          ),
        ),
        Positioned(
          bottom: 12,
          child: SmoothPageIndicator(
            controller: pageController,
            count: tariffs.length,
            axisDirection: Axis.horizontal,
            effect: CustomizableEffect(
              spacing: 4,
              dotDecoration: DotDecoration(
                width: 5,
                height: 5,
                color: NannyTheme.primary.withOpacity(0.45),
                borderRadius: BorderRadius.circular(100),
              ),
              activeDotDecoration: DotDecoration(
                width: 8,
                height: 8,
                color: NannyTheme.primary,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            onDotClicked: (index) => pageController.animateToPage(index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear),
          ),
        ),
      ],
    );
  }
}

/// Форматирование валюты
String formatCurrency(double value) {
  final formatter = NumberFormat("#,##0.0", "en_US");
  String formatted = formatter.format(value).replaceFirst('.', ',');
  return "$formatted Р";
}
