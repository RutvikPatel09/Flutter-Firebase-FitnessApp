import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:supreme_fitness/StepsCounter/widget/containerButton.dart';
import 'package:supreme_fitness/StepsCounter/widget/textWidget.dart';

import 'imageContainer.dart';

class dashboardCard extends StatelessWidget {
  int steps;
  double miles, calories, duration;
  dashboardCard(this.steps, this.miles, this.calories, this.duration,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 5, right: 5),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color(0xff1D3768),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        child: Column(
                          children: [
                            // this is for the count in foot step and edit button
                            Container(
                              width: 150,
                              child: Row(
                                children: [
                                  text(53, steps.toString()),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 130,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),

              const SizedBox(
                height: 80,
              ),
              // this is botton part
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  imageContainer("assets/locations.png",
                      miles.toStringAsFixed(3), "Miles"),
                  imageContainer("assets/calories.png",
                      calories.toStringAsFixed(3), "Calories"),
                  imageContainer("assets/stopwatch.png",
                      duration.toStringAsFixed(3), "Duration"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
