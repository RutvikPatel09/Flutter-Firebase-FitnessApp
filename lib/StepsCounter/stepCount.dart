import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supreme_fitness/StepsCounter/widget/DashoardCard.dart';
import 'package:supreme_fitness/StepsCounter/widget/buttonNav.dart';
import 'package:supreme_fitness/StepsCounter/widget/containerButton.dart';
import 'package:supreme_fitness/StepsCounter/widget/dailyAverage.dart';
import 'package:supreme_fitness/StepsCounter/widget/topTextButton.dart';

class countSteps extends StatefulWidget {
  const countSteps({Key? key}) : super(key: key);

  @override
  _countStepsState createState() => _countStepsState();
}

class _countStepsState extends State<countSteps> {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  double miles = 0.0;
  double duration = 0.0;
  double calories = 0.0;
  double addValue = 0.025;
  int steps = 0;
  double previousDistacne = 0.0;
  double distance = 0.0;

  @override
  void initState() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      var x = event.x;
      var y = event.y;
      var z = event.z;
    });
    setState(() {
      accelerometerEvents;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 26, 46, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(9, 26, 46, 1),
        shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(0),
        title: Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: Text(
            "Step Count",
            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
          ),
        ),
      ),

      body: StreamBuilder<AccelerometerEvent>(
        stream: SensorsPlatform.instance.accelerometerEvents,
        builder: (context, snapShort) {
          if (snapShort.hasData) {
            x = snapShort.data!.x;
            y = snapShort.data!.y;
            z = snapShort.data!.z;
            distance = getValue(x, y, z);
            if (distance > 20) {
              steps++;
            }
            calories = calculateCalories(steps);
            duration = calculateDuration(steps);
            miles = calculateMiles(steps);
          }
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color.fromRGBO(9, 26, 46, 1),
                      Color.fromRGBO(9, 26, 46, 1),
                    ])),
              ),
              // ignore: sized_box_for_whitespace
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(
                        height: kToolbarHeight,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            topText("Today", true, () {
                              //print("This was tapped");
                            }),
                            // this is the farthest button
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                            ),
                          ],
                        ),
                      ),
                      // dashboard card
                      dashboardCard(steps, miles, calories, duration),
                      //const dailyAverage(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      //bottomNavigationBar: const buttonNav(),
    );
  }

  double getValue(double x, double y, double z) {
    double magnitude = sqrt(x * x + y * y + z * z);
    getPreviousValue();
    double modDistance = magnitude - previousDistacne;
    setPreviousValue(magnitude);
    return modDistance;
  }

  void setPreviousValue(double distance) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setDouble("preValue", distance);
  }

  void getPreviousValue() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      previousDistacne = _pref.getDouble("preValue") ?? 0.0;
    });
  }

  // void calculate data
  double calculateMiles(int steps) {
    double milesValue = (2.2 * steps) / 5280;
    return milesValue;
  }

  double calculateDuration(int steps) {
    double durationValue = (steps * 1 / 1000);
    return durationValue;
  }

  double calculateCalories(int steps) {
    double caloriesValue = (steps * 0.0566);
    return caloriesValue;
  }
}
