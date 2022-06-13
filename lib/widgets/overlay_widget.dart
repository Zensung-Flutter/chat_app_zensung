import 'package:flutter/material.dart';

class OverlLayWidget extends StatelessWidget {
  const OverlLayWidget({Key? key, required this.middleX, required this.middleY})
      : super(key: key);
  final double middleX;
  final double middleY;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.withOpacity(0),
      child: Container(
        height: middleX,
        width: middleY,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ))),
      ),
    );
  }
}
