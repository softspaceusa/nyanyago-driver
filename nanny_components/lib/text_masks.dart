import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nanny_core/nanny_core.dart';

class TextMasks {
  static CustomPhoneInputFormatter phoneMask() => CustomPhoneInputFormatter();

  static MaskTextInputFormatter digitsMask(int max) {
    String mask = "";
    for (int i = 0; i < max; i++) {
      mask += '#';
    }
    return MaskTextInputFormatter(
      mask: mask,
      filter: {'#': RegExp(r'[0-9]')},
    );
  }
}

class NannyUpperFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class NannyDateFormatter extends TextInputFormatter {
  NannyDateFormatter({required this.checkYear});

  String _text = "";

  String get text => _text;

  final bool checkYear;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    print('inex of dot ${newText.indexOf('.')}');
    if ((newText.contains('.') &&
            (newText.indexOf('.') != 2 && newText.indexOf('.') != 5)) ||
        newText.contains(' ') ||
        newText.contains(',') ||
        newText.contains('-') ||
        newText.length > 10) {
      return oldValue;
    }
    _text = newText;
    if (_text.contains('.')) _text = _text.replaceAll('.', '');
    int length = _text.length;

    if (length > 4) {
      _text =
          "${_text.substring(0, 2)}.${_text.substring(2, 4)}.${_text.substring(4)}";
    } else if (length > 2) {
      _text = "${_text.substring(0, 2)}.${_text.substring(2)}";
    }

    if (text.isEmpty) return newValue;

    var parts = NannyUtils.retreiveDateParts(_text);

    switch (parts.length) {
      case 1:
        if (parts.first > 31) return oldValue;
        break;

      case 2:
        if (parts[1] > 12) return oldValue;
        break;

      case 3:
        if (checkYear && parts[2] > DateTime.now().year) return oldValue;
        break;
    }

    return TextEditingValue(text: _text);
  }
}

class CustomPhoneInputFormatter extends MaskTextInputFormatter {
  CustomPhoneInputFormatter()
      : super(
          mask: '+ 7 (###) ###-##-##',
          filter: {'#': RegExp(r'[0-9]')},
        );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // Проверяем, вставлен ли текст (разница длин больше одного символа)
    if (newValue.text.length - oldValue.text.length > 1) {
      // Если вставленный текст начинается с +7, 7 или 8
      if (newText.startsWith('+7')) {
        newText = newText.replaceFirst('+7', '');
      } else if (newText.startsWith('7')) {
        newText = newText.substring(1);
      } else if (newText.startsWith('8')) {
        newText = newText.substring(1);
      }
    }

    // Форматируем текст с помощью MaskTextInputFormatter
    final updatedValue = super.formatEditUpdate(
        oldValue,
        TextEditingValue(
          text: newText,
          selection: newValue.selection,
        ));

    return updatedValue;
  }
}
