import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:supreme_fitness/BMI/bmi_calculator.dart';
import 'package:supreme_fitness/Exercise/exercise.dart';
import 'package:supreme_fitness/Exercise/showExercise.dart';
import 'package:supreme_fitness/ExerciseCategory/showCategory.dart';
import 'package:supreme_fitness/Feedback/feedback.dart';
import 'package:supreme_fitness/healthyFood/WeightGainFood.dart';
import 'package:supreme_fitness/healthyFood/healthyFood.dart';
import 'package:supreme_fitness/login.dart';
import 'package:supreme_fitness/register.dart';

import '../../Declarations/DashboardScreen.dart';
import '../../Declarations/Images/ImageFiles.dart';
import '../../ExerciseCategory/category.dart';
import '../../General Widgets/GWidgets.dart';

Widget buildRightContainer(BuildContext context, int colorIndex, String title,
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
      left: 10,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
          color: dashboardColors[colorIndex],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.00),
            bottomLeft: Radius.circular(15.00),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            buildImage(imageIndex, context),
            buildPreview(colorIndex, title),
            buildText(context, subTitle),
          ],
        ),
      ),
    );

List screens = [null,const showCategory(), null, const WeightGainFood(),null,const FeedbackData()];

Widget buildImage(int imageIndex, BuildContext context) => Positioned(
      top: -45,
      bottom: 10,
      left: imageIndex == 1
          ? -25
          : imageIndex == 5
              ? -65
              : imageIndex == 3
                  ? 17.5
                  : 25,
      child: GestureDetector(
        onTap: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => screens[imageIndex]))
        },
        child: Image.asset(
          dashboardImages[imageIndex],
          fit: BoxFit.contain,
        ),
      ),
    );

Widget buildPreview(int colorIndex, String title) => Positioned(
      top: -25,
      right: 30,
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
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Text(
              subTitle,
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 27.00,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        widthSpacer(50.00),
      ],
    );
