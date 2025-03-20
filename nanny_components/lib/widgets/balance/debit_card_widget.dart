import 'package:flutter/material.dart';
import 'package:nanny_components/styles/nanny_theme.dart';
import 'package:nanny_core/models/from_api/user_cards.dart';

class DebitCardWidget extends StatelessWidget {
  const DebitCardWidget({
    super.key,
    this.card,
    required this.size,
    this.isSelected = false,
    this.onTap,
    this.onLongTap,
    this.onAddCard,
    this.isAddCardWidget = false,
  });

  final UserCardData? card;
  final Size size;
  final bool isSelected;
  final Function(int id)? onTap;
  final Function(int id)? onLongTap;
  final Function()? onAddCard;
  final bool isAddCardWidget;

  @override
  Widget build(BuildContext context) {
    LinearGradient? gradient = switch (card?.bank.toLowerCase() ?? 'null') {
      "null" => const LinearGradient(
          colors: [NannyTheme.darkGrey, NannyTheme.onPrimary]),
      "mir" =>
        const LinearGradient(colors: [NannyTheme.green, NannyTheme.onPrimary]),
      "visa" =>
        const LinearGradient(colors: [Colors.purple, NannyTheme.onPrimary]),
      "mastercard" => const LinearGradient(colors: [Colors.red, Colors.orange]),
      _ => const LinearGradient(colors: [NannyTheme.onPrimary]),
    };

    return SizedBox(
      height: size.width * .5,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ElevatedButton(
          onPressed: isAddCardWidget ? onAddCard : () => onTap?.call(card!.id),
          onLongPress: isAddCardWidget ? null : () => onLongTap?.call(card!.id),
          style: isSelected
              ? ElevatedButton.styleFrom(
                  foregroundColor: NannyTheme.onSecondary,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: NannyTheme.green,
                        width: 5,
                      )),
                  padding: EdgeInsets.zero,
                )
              : ElevatedButton.styleFrom(
                  foregroundColor: NannyTheme.onSecondary,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment:
                  isAddCardWidget ? Alignment.center : Alignment.bottomCenter,
              child: isAddCardWidget
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_rounded, size: 40),
                        SizedBox(width: 10),
                        Text('Добавить карту'),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(card?.cardNumber ?? ''),
                        Text(card?.bank ?? ''),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
