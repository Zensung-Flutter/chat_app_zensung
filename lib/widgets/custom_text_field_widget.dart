import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget({
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
        suffixIcon: iconButton ??
            Container(
              height: 0,
              width: 0,
            ),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 5,
            ),
            Icon(icon, color: Colors.grey),
            SizedBox(
              width: 5,
            ),
            Container(
              height: 25,
              width: 2,
              color: Colors.black,
            ),
          ],
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
