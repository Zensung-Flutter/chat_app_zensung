import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  CustomTextFieldWidget({
    Key? key,
    required this.labelText,
    required this.icon,
    this.isObscure,
    required this.textEditingController,
    this.iconButton,
    this.isPasswordObscure,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final String labelText;
  final IconData icon;
  final bool? isObscure;
  final bool? isPasswordObscure;
  final IconButton? iconButton;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      obscureText: isObscure ?? false,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: iconButton ??
            Container(
              height: 1,
              width: 1,
            ),
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
