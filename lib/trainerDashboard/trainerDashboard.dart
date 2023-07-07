import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';

class trainerDashoard extends StatefulWidget {
  const trainerDashoard({super.key});

  @override
  State<trainerDashoard> createState() => _trainerDashoardState();
}

class _trainerDashoardState extends State<trainerDashoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: dashboardColors[10],
        shadowColor: dashboardColors[10].withAlpha(0),
        title: const Text(
          "Trainer Dashboard",
          style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
        )
      ),
    );
  }
}