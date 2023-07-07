import 'package:flutter/material.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  int currentindex = 0;
  late String result = "";
  double height = 0;
  double weight = 0;
  String msg = "";

  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(9, 26, 46, 1),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(9, 26, 46, 1),
          shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(0),
          title: const Text(
            "BMI Calculator",
            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    radioButton("Man", Color.fromRGBO(255, 207, 96, 1), 0),
                    radioButton("Woman", Colors.black, 1),
                  ],
                ),
                const SizedBox(
                  height: 20,
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
                      });
                      calculateBMI(height, weight);
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
                  child: const Text(
                    "Your BMI is: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "$msg\n$result",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculateBMI(double height, double weight) {
    double finalresult = weight / (height * height / 10000);
    String bmi = finalresult.toStringAsFixed(2);
    //var msg = "";
    if (finalresult > 25) {
      msg = "You're OverWeight!!!!";
    } else if (finalresult < 18) {
      msg = "You're UnderWeight!!!!";
    } else {
      msg = "You're Healthy!!!!";
    }
    setState(() {
      result = bmi;
    });
  }

  void changeIndex(int index) {
    currentindex = index;
  }

  Widget radioButton(String value, Color color, int index) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 80.0,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    currentindex == index ? color : Colors.grey[200],
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              onPressed: () {
                changeIndex(index);
                //print("object");
              },
              child: Text(
                value,
                style: TextStyle(
                    color: currentindex == index ? Colors.white : color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              // FlatButton(
              //   color: currentindex == index ? color : Colors.grey[200],
              //   shape:RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(8.0)
              //   ),
              //   onPressed: (){
              //     changeIndex(index);
              //   },
              //   child:Text(value, style: TextStyle(
              //     color: currentindex == index ? Colors.white : color
              //   ),)
              // ),
            )));
  }
}
