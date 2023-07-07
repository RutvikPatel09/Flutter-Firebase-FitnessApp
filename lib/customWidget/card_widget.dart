import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CardWidget extends StatelessWidget {
  final String cardImg;

  const CardWidget({required this.cardImg, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: 150,
        width: 340,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(cardImg), fit: BoxFit.fill),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
