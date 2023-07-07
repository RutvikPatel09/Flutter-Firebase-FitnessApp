import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path/path.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:supreme_fitness/healthyFood/WeightGainFood.dart';
import 'package:supreme_fitness/healthyFood/WeightLoss.dart';

class HealthyFood extends StatefulWidget {
  const HealthyFood({super.key});

  @override
  State<HealthyFood> createState() => _HealthyFoodState();
}

class _HealthyFoodState extends State<HealthyFood> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: dashboardColors[10],
        shadowColor: dashboardColors[10].withAlpha(0),
        title: const Text(
          "Healthy Food",
          style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 0,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 48.0, left: 10.0, right: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WeightGainFood()));
                        },
                        child: Image(
                            image: NetworkImage(
                                "https://fitelo.co/wp-content/uploads/2022/08/image_6487327.jpg")),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Weight Gain Foods",
                      style: TextStyle(fontFamily: 'Montserrat'),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 48.0, left: 10.0, right: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (Context) => WeightLossFood()));
                        },
                        child: Image(
                            image: NetworkImage(
                                "https://www.foodfitnessnfun.com/wp-content/uploads/2022/09/Foods-for-instant-fat-loss-770-%C3%97-500-px-1-770x500.png")),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Weight Loss Foods",
                      style: TextStyle(fontFamily: 'Montserrat'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
