import 'package:flutter/material.dart';

class CardWidget2 extends StatelessWidget {
  final String cardImg;

  const CardWidget2({required this.cardImg, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: 100,
        width: 120,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(cardImg), fit: BoxFit.fill),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
