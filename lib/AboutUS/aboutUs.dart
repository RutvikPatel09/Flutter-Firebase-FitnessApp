import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class aboutUs extends StatefulWidget {
  const aboutUs({super.key});

  @override
  State<aboutUs> createState() => _aboutUsState();
}

class _aboutUsState extends State<aboutUs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(9, 26, 46, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icon/dumbbell.png",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Supreme Fitness",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
          ),
          Text(
            "Helping you to get great health & fitness.",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 5.0, top: 20.0),
            child: Text(
              "We Provide wide variety of Exercises, Healthy Food, Exercises Videos, Live Chat Support and AI chatbot.",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 6.0, right: 6.0),
            child: Text(
                "With the help of above services you can make your body fit and in shape.",
                style: TextStyle(fontSize: 15, color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text(
              "Join Us At",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  "__________________________",
                  style: TextStyle(color: Color.fromRGBO(255, 207, 96, 1)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text("__________________________",
                    style: TextStyle(color: Color.fromRGBO(255, 207, 96, 1))),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tooltip(
                message: 'Quora',
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(255, 207, 96, 1),
                      ),
                      child: new Icon(
                        FontAwesomeIcons.quora,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: 'Facebook',
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(255, 207, 96, 1),
                      ),
                      child: new Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: 'Instagram',
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(255, 207, 96, 1),
                      ),
                      child: new Icon(
                        FontAwesomeIcons.instagram,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: 'Github',
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(255, 207, 96, 1),
                      ),
                      child: new Icon(
                        FontAwesomeIcons.github,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
