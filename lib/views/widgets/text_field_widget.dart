import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final String? errorText;
  final bool? enabled;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Function(String)? onChanged;

  const TextFieldWidget(
      {super.key,
      required this.labelText,
      this.controller,
      this.errorText,
      this.enabled,
      this.readOnly,
      this.keyboardType,
      this.onChanged,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        errorText: errorText,
        enabled: enabled ?? true,
      ),
      onChanged: (value) => onChanged?.call(value),
      keyboardType: keyboardType ?? TextInputType.text,
      readOnly: readOnly ?? false,
      controller: controller,
      obscureText: obscureText ?? false,
    );
  }
}
