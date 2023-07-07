import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supreme_fitness/OTPVerification/verify.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  var phone = "";

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("addTrainer");

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSnack(String title) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
      ),
    ));
    scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
  }

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            margin: EdgeInsets.only(left: 25, right: 25),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 90.0, right: 150),
                    child: Text(
                      "Phone\nVerification",
                      style: TextStyle(
                          fontSize: 33,
                          color: Color.fromRGBO(
                                                            255, 207, 96, 1),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Image.asset(
                      'assets/images/img1.png',
                      width: 190,
                      height: 190,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "We need to register your phone without getting started!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 40,
                          child: TextField(
                            controller: countryController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Text(
                          "|",
                          style: TextStyle(fontSize: 33, color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: TextField(
                          onChanged: (value) => {phone = value},
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone",
                          ),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(
                                                            255, 207, 96, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          QuerySnapshot querySnapshot =
                              await collectionReference.get();

                          final phoneNumber = querySnapshot.docs
                              .map((e) => e['Phone'])
                              .toList();

                          // var phoneString = phoneNumber.join(',');
                          var phoneList = phone.split(',');

                          var firstListSet = phoneNumber.toSet();
                          var secondListSet = phoneList.toSet();

                          //print(phoneList);
                          //print(phoneNumber);
                          //print(phoneNumber);
                          //print(firstListSet.intersection(secondListSet));
                          // var result =
                          //     firstListSet.intersection(secondListSet);
                          // print(result);

                          if (secondListSet.every(
                              (element) => firstListSet.contains(element))) {
                            //print("Success");

                            FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber:
                                    '${countryController.text + phone}',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed:
                                    (FirebaseAuthException e) {},
                                codeSent: (String verificationId,
                                    forceResendingToken) {
                                  MyPhone.verify = verificationId;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyVerify()));
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {});
                          } else {
                            //print("Fail");
                            showSnack("Phone Number Doesn't Exist...!!!");
                          }
                        },
                        child: Text(
                          "Send the code",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
