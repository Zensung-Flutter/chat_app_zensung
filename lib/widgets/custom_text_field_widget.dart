import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget({
    Key? key,
    required this.labelText,
    required this.icon,
    this.isObscure,
    required this.textEditingController,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final String labelText;
  final IconData icon;
  final bool? isObscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      obscureText: isObscure ?? false,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelStyle: TextStyle(color: Colors.purple),
        labelText: labelText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.purple, width: 2),
        ),
      ),
    );
  }
}
