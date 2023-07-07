import 'package:flutter/material.dart';
import 'package:supreme_fitness/AI%20BOT%20With%20ChatGPT/AIBOT.dart';
import 'package:supreme_fitness/BMI/bmi_calculator.dart';
import 'package:supreme_fitness/Exercise/showExercise.dart';
import 'package:supreme_fitness/Feedback/feedback.dart';
import 'package:supreme_fitness/uploadVideos/showVideos.dart';

import '../../Declarations/DashboardScreen.dart';
import '../../Declarations/Images/ImageFiles.dart';
import '../../General Widgets/GWidgets.dart';

Widget buildLeftContainer(BuildContext context, int colorIndex, String title,
        String subTitle, int imageIndex) =>
    Container(
      height: 150,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          buildContainer(context, colorIndex, title, subTitle, imageIndex),
        ],
      ),
    );

Widget buildContainer(BuildContext context, int colorIndex, String title,
        String subTitle, int imageIndex) =>
    Positioned(
      right: 10,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
          color: dashboardColors[colorIndex],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.00),
            bottomRight: Radius.circular(15.00),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            buildImage(imageIndex,context),
            buildPreview(colorIndex, title),
            buildText(context, subTitle),
          ],
        ),
      ),
    );

List screens = [null, null, const BMICalculator(), null,const showVideos(),null,const AIBOT()];

Widget buildImage(int imageIndex, BuildContext context) => Positioned(
      top: -45,
      bottom: 10,
      right: 0,
      child: Container(
          width: 125,
          height: 125,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => screens[imageIndex]));
            },
            child: Image.asset(
              dashboardImages[imageIndex],
              fit: BoxFit.contain,
            ),
          )),
    );

Widget buildPreview(int colorIndex, String title) => Positioned(
      top: -25,
      left: 30,
      child: Container(
        height: 50,
        width: 175,
        decoration: BoxDecoration(
          color: dashboardColors[colorIndex + 1],
          borderRadius: BorderRadius.circular(15.00),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 27.00,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

Widget buildText(BuildContext context, String subTitle) => Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widthSpacer(50.00),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Text(
              subTitle,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 27.00,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
