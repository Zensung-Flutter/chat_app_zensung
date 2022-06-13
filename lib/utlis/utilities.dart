import 'dart:math';

import 'package:flutter/material.dart';

Widget getUserInitials(String firstName, String lastName) {
  String nameInitial = firstName.substring(0, 1);
  String lastNameInitial = lastName.substring(0, 1);
  String userInitials = nameInitial + lastNameInitial;
  final _random = Random();
  return Container(
    width: 70,
    height: 70,
    child: Center(
      child: Text(
        userInitials,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color:
            Color((_random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)),
  );
}

String getUserName(String firstName, String lastName) {
  var name = firstName.substring(0, 5);
  return '$name $lastName';
}
