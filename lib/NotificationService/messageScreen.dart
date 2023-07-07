import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageScr extends StatefulWidget {
  final String id;
  const MessageScr({super.key, required this.id});

  @override
  State<MessageScr> createState() => _MessageScrState();
}

class _MessageScrState extends State<MessageScr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: Color.fromRGBO(9, 26, 46, 1),
      shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(0),
      title: Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          'appName'.tr + ' ' + widget.id,
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500),
        ),
      ),
    ));
  }
}
