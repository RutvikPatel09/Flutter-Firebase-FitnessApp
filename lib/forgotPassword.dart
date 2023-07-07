import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supreme_fitness/login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final FocusNode focusEmail = FocusNode();
  final TextEditingController emailController = TextEditingController();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSnack(String title) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
      ),
    ));
    scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: (Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //       image: AssetImage('assets/images/login.png'),
          //       fit: BoxFit.cover),
          // ),
          child: Scaffold(
            backgroundColor: Color.fromRGBO(9, 26, 46, 1),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 90.0, top: 180),
                  child: Container(
                    child: Image.asset(
                      "assets/images/password.png",
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 35, top: 75),
                  child: const Text(
                    'Forgot\nYour Password?',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 33),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
                              TextField(
                                style: const TextStyle(color: Colors.white),
                                cursorColor: Colors.yellow,
                                controller: emailController,
                                focusNode: focusEmail,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    fillColor: Color.fromRGBO(59, 72, 89, 1),
                                    hintStyle: TextStyle(color: Colors.white),
                                    filled: true,
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                        fontSize: 27,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        Color.fromRGBO(255, 207, 96, 1),
                                    child: IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          String email = emailController.text;
                                          if (email.isEmpty ||
                                              !RegExp("^[a-zA-z0-9+_.-]+@[a-zA-z0-9.-]+.[a-z]")
                                                  .hasMatch(email)) {
                                            showSnack(
                                                'Please Enter Correct Email!!!');
                                          }
                                          FirebaseAuth.instance
                                              .sendPasswordResetEmail(
                                                  email: emailController.text);
                                          //.then((value) =>
                                          //  Navigator.of(context)
                                          //    .pop());
                                          final message =
                                              'Reset link has been sended to your email.';
                                          Fluttertoast.showToast(
                                              msg: message, fontSize: 16);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MyLogin()));
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                        )),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
