import 'package:flutter/material.dart';

class dailyCaloriesNeed extends StatefulWidget {
  const dailyCaloriesNeed({super.key});

  @override
  State<dailyCaloriesNeed> createState() => _dailyCaloriesNeedState();
}

class _dailyCaloriesNeedState extends State<dailyCaloriesNeed> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  late String result = "";
  double height = 0;
  double weight = 0;
  double age = 0;
  String msg = "";
  var selectedType;
  var selectedType1;
  var AMR;

  late String loseweightTen = "";
  late String loseweightTwenty = "";
  late String gainweightTen = "";
  late String gainweightTwenty = "";

  List data = [
    "Sedentary (little or no exercise)",
    "Lightly active (exercise 1–3 days/week)",
    "Moderately active (exercise 3–5 days/week)",
    "Active (exercise 6–7 days/week)",
    "Very active (hard exercise 6–7 days/week)"
  ];

  List gender = ["Male", "Female"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(9, 26, 46, 1),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(9, 26, 46, 1),
          shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(0),
          title: const Text(
            "Count Daily Calories",
            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(top: 2.0, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Your Age in Years: ",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: ageController,
                decoration: InputDecoration(
                    hintText: "Your Age in Years",
                    fillColor: Color.fromRGBO(59, 72, 89, 1),
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Your Height in CM: ",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: heightController,
                decoration: InputDecoration(
                    hintText: "Your Height in CM",
                    fillColor: Color.fromRGBO(59, 72, 89, 1),
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none)),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Your Weight in KG: ",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                controller: weightController,
                decoration: InputDecoration(
                    fillColor: Color.fromRGBO(59, 72, 89, 1),
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: "Your Weight in KG",
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none)),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: DropdownButton(
                  dropdownColor: Colors.black,
                  items: gender
                      .map((value) => DropdownMenuItem(
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.white),
                            ),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (selectedValue) {
                    setState(() {
                      selectedType1 = selectedValue;
                    });
                  },
                  value: selectedType1,
                  style:
                      TextStyle(backgroundColor: Color.fromRGBO(9, 26, 46, 1)),
                  isExpanded: false,
                  hint: Text(
                    "Choose Gender",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: DropdownButton(
                  dropdownColor: Colors.black,
                  items: data
                      .map((value) => DropdownMenuItem(
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.white),
                            ),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (selectedValue) {
                    setState(() {
                      selectedType = selectedValue;
                    });
                  },
                  value: selectedType,
                  style:
                      TextStyle(backgroundColor: Color.fromRGBO(9, 26, 46, 1)),
                  isExpanded: false,
                  hint: Text(
                    "Choose Exercise Mode",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromRGBO(255, 207, 96, 1),
                ),
                width: double.infinity,
                height: 60.0,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      height = double.parse(heightController.value.text);
                      weight = double.parse(weightController.value.text);
                      age = double.parse(ageController.value.text);
                    });
                    countCalories(age, height, weight);
                    FocusScope.of(context).unfocus();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 207, 96, 1),
                  ),
                  child: const Text(
                    'Calculate',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "Your daily calories:- $result" +
                      "\n" +
                      "Maintain Weight:- $result" +
                      "\n" +
                      "Lose Weight 10%(Week):- $loseweightTen" +
                      "\n" +
                      "Lose Weight 20%(Week):- $loseweightTwenty" +
                      "\n" +
                      "Gain Weight 10%(Week):- $gainweightTen" +
                      "\n" +
                      "Gain Weight 20%(Week):- $gainweightTwenty",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        )));
  }

  void countCalories(double age, double height, double weight) {
    String exerciseMode = selectedType.toString();
    String gender = selectedType1.toString();

    if (gender == "Male") {
      double BMR = 66 + (13.7 * weight) + (5 * height) - (6.8 * age);
      if (exerciseMode == "Sedentary (little or no exercise)") {
        var calculateAMR = BMR * 1.2;
        setState(() {
          AMR = calculateAMR;
        });
      } else if (exerciseMode == "Lightly active (exercise 1–3 days/week)") {
        var calculateAMR = BMR * 1.375;
        setState(() {
          AMR = calculateAMR;
        });
      } else if (exerciseMode == "Moderately active (exercise 3–5 days/week)") {
        var calculateAMR = BMR * 1.55;
        setState(() {
          AMR = calculateAMR;
        });
      } else if (exerciseMode == "Active (exercise 6–7 days/week)") {
        var calculateAMR = BMR * 1.725;
        setState(() {
          AMR = calculateAMR;
        });
      } else if (exerciseMode == "Very active (hard exercise 6–7 days/week)") {
        var calculateAMR = BMR * 1.9;
        setState(() {
          AMR = calculateAMR;
        });
      }
    } else {
      double BMR = 655 + (9.6 * weight) + (1.8 * height) - (4.7 * age);
      if (exerciseMode == "Sedentary (little or no exercise)") {
        var calculateAMR = BMR * 1.2;
        setState(() {
          AMR = calculateAMR;
        });
      } else if (exerciseMode == "Lightly active (exercise 1–3 days/week)") {
        var calculateAMR = BMR * 1.375;
        setState(() {
          AMR = calculateAMR;
        });
      } else if (exerciseMode == "Moderately active (exercise 3–5 days/week)") {
        var calculateAMR = BMR * 1.55;
        setState(() {
          AMR = calculateAMR;
        });
      } else if (exerciseMode == "Active (exercise 6–7 days/week)") {
        var calculateAMR = BMR * 1.725;
        setState(() {
          AMR = calculateAMR;
        });
      } else if (exerciseMode == "Very active (hard exercise 6–7 days/week)") {
        var calculateAMR = BMR * 1.9;
        setState(() {
          AMR = calculateAMR;
        });
      }
    }

    setState(() {
      var loseweightten = AMR - (AMR * 10 / 100);
      var loseweighttwenty = AMR - (AMR * 20 / 100);
      var gainweightten = AMR + (AMR * 10 / 100);
      var gainweighttwenty = AMR + (AMR * 20 / 100);

      result = AMR.toStringAsFixed(2);

      loseweightTen = loseweightten.toStringAsFixed(2);
      loseweightTwenty = loseweighttwenty.toStringAsFixed(2);
      gainweightTen = gainweightten.toStringAsFixed(2);
      gainweightTwenty = gainweighttwenty.toStringAsFixed(2);
    });
  }
}
