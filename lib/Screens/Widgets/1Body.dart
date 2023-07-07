import 'package:flutter/material.dart';
import 'package:supreme_fitness/customWidget/card_widget.dart';

import '../../General Widgets/GWidgets.dart';
import '2TopClipper.dart';
import '3RightContainers.dart';
import '4LeftContainers.dart';

Widget buildBody(BuildContext context) => Container(
      child: SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (MediaQuery.of(context).size.height),
            ),
            child: buildRender(context)),
      ),
    );

List<String> cardList = [
  "assets/images/challenge.png",
  "assets/images/fitnesss.png",
  "assets/images/challenge.png",
  "assets/images/fitnesss.png",
];

Widget cardImage(BuildContext context) => Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: false,
        itemCount: 4,
        itemBuilder: (context, index) {
          return CardWidget(cardImg: cardList[index]);
        },
      ),
    );

Widget buildRender(BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        heightSpacer(20.00),
        cardImage(context),
        heightSpacer(25.00),
        buildTopClipper(context),
        heightSpacer(25.00),
        buildRightContainer(context, 0, "Workouts", "Regular Workouts", 1),
        heightSpacer(50.00),
        buildLeftContainer(context, 2, "BMI", "Calculate Your BMI", 2),
        heightSpacer(50.00),
        buildRightContainer(context, 4, "Healthy Food", "Nutritions & Diet", 3),
        heightSpacer(50.00),
        buildLeftContainer(context, 6, "Videos", "Learn Exercises", 4),
        heightSpacer(50.00),
        buildRightContainer(
            context, 8, "Feedback", "Give Your Valuable Feedback", 5),
        heightSpacer(50.00),
        buildLeftContainer(context, 9, "AI Bot", "Ask Your Questions", 6),
        heightSpacer(25.00),
      ],
    );
