import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  CustomTextFieldWidget({
    Key? key,
    required this.labelText,
    required this.icon,
    this.isObscure,
    required this.textEditingController,
    this.iconButton,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final String labelText;
  final IconData icon;
  final bool? isObscure;
  final IconButton? iconButton;
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
        suffixIcon: iconButton ??
            Container(
              width: 0,
            ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.purple, width: 2),
        ),
      ),
    );
  }
}
