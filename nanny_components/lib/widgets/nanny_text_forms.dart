import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanny_components/styles/text_styles.dart';

class NannyTextForm extends StatelessWidget {
  final InputDecoration? style;
  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final TextInputType? keyType;
  final List<TextInputFormatter>? formatters;
  final void Function(String text)? onChanged;
  final VoidCallback? onTap;
  final String? Function(String? text)? validator;
  final bool readOnly;
  final bool enabled;
  final TextEditingController? controller;
  final int? maxLines;
  final int? maxLength;

  const NannyTextForm({
    super.key,
    this.onChanged,
    this.onTap,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.formatters,
    this.keyType,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.style,
    this.controller,
    this.maxLines,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: NannyTextStyles.textTheme.bodyMedium?.copyWith(height: 1.5),

      // style: NannyTextStyles.textTheme.bodyMedium,
      textAlignVertical: TextAlignVertical.center,
      decoration: style?.copyWith(
            labelText: labelText,
            hintText: hintText,
          ) ??
          InputDecoration(
            labelText: labelText,
            hintText: hintText,
          ),
      inputFormatters: formatters,
      keyboardType: keyType,
      validator: validator,
      initialValue: initialValue,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,

      onChanged: onChanged,
      onTap: onTap,
      controller: controller,
    );
  }
}

class NannyPasswordForm extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextInputType? keyType;
  final List<TextInputFormatter>? formatters;
  final void Function(String text) onChanged;
  final String? Function(String? text)? validator;

  const NannyPasswordForm({
    super.key,
    required this.onChanged,
    this.hintText,
    this.labelText,
    this.formatters,
    this.keyType,
    this.validator,
  });

  @override
  State<NannyPasswordForm> createState() => _NannyPasswordFormState();
}

class _NannyPasswordFormState extends State<NannyPasswordForm> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: obscure,
        style: NannyTextStyles.textTheme.bodyMedium,
        decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            suffixIcon: IconButton(
                onPressed: () => setState(() {
                      obscure = !obscure;
                    }),
                icon: Icon(obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined))),
        inputFormatters: widget.formatters,
        keyboardType: widget.keyType,
        validator: widget.validator,
        onChanged: widget.onChanged);
  }
}
