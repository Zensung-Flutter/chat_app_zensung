import 'package:chat_app/utlis/utilities.dart';
import 'package:flutter/material.dart';

class SenderChatBubbleWidget extends StatelessWidget {
  const SenderChatBubbleWidget({
    Key? key,
    required this.width,
    required this.message,
    required this.dateTime,
  }) : super(key: key);

  final double width;
  final String message;
  final int dateTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width * 0.8),
          child: Card(
            child: Container(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(message),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(getDateTime(dateTime)),
                    ],
                  )
                ],
              ),
            )),
          ),
        ),
      ],
    );
  }
}

class RecieverChatBubbleWidget extends StatelessWidget {
  const RecieverChatBubbleWidget({
    Key? key,
    required this.width,
    required this.message,
    required this.dateTime,
  }) : super(key: key);

  final double width;
  final String message;
  final int dateTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width * 0.8),
          child: Card(
            child: Container(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(message),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(getDateTime(dateTime)),
                    ],
                  )
                ],
              ),
            )),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
