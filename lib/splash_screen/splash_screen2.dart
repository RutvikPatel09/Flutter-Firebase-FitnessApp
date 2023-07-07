import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:supreme_fitness/login.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
              'https://assets9.lottiefiles.com/packages/lf20_oncjxjbd.json',
              controller: _controller, onLoaded: (compose) {
            _controller
              ..duration = compose.duration
              ..forward()
              .then((value) {
                
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => MyLogin()));
              });
          }),
        ],
      ),
    );
  }
}
