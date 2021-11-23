import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final int maxLInes;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final bool enabled;
  final List<TextInputFormatter>? formatters;
  final Function(String?)? onChanged;
  const TextFieldWidget({
    Key? key,
    required this.label,
    this.hintText,
    this.maxLInes = 1,
    this.textInputType,
    this.validator,
    this.controller,
    this.enabled = true,
    this.formatters,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: 'Poppins-Regular',
        color: Colors.black87,
      ),
      onChanged: onChanged,
      enabled: enabled,
      controller: controller,
      keyboardType: textInputType,
      inputFormatters: formatters,
      maxLines: maxLInes,
      validator: validator,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
            width: 0.5,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
            width: 0.5,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Poppins-Regular',
          fontSize: 12,
          color: Colors.black.withOpacity(
            0.5,
          ),
        ),
        label: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: 17,
            color: Colors.black.withOpacity(
              0.7,
            ),
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
