import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supreme_fitness/Stripe%20Payment/paymentController.dart';

import '../Declarations/DashboardScreen.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());
    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 26, 46, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(9, 26, 46, 1),
        shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(0),
        title: Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: Text(
            "Take Subscription",
            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 108.0, left: 10, right: 10),
            child: Text(
              "Note: If payment is deducted and you will not get the subscription do contact us on:-" +
                  "SupremeFitness@gmail.com",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          InkWell(
            onTap: () {
              controller.makePayment(amount: '499', currency: 'INR');
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 207, 96, 1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(9, 26, 46, 1),
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Make Payment',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
