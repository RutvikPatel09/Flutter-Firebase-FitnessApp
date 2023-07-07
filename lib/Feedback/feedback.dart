import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';

import '../providers/feedbackProvider.dart';

class FeedbackData extends StatefulWidget {
  const FeedbackData({super.key});

  @override
  State<FeedbackData> createState() => _FeedbackDataState();
}

class _FeedbackDataState extends State<FeedbackData> {
  final TextEditingController FeedbackDesc = TextEditingController();
  final TextEditingController Name = TextEditingController();

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: FeedbackDesc,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: InputDecoration(
                      labelText: "Feedback",
                )),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Send'),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(255, 207, 96, 1)),
                  onPressed: () {
                    // UserProvider userProvider = Provider.of(context, listen: false);
                    // userProvider.getUserData();
                    // UserModel data = userProvider.getUserDataList as UserModel;
                    // final String name = data.userName;
                    final String FeedbackDescData = FeedbackDesc.text;
                    DateTime currentDate = DateTime.now();
                    Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
                    DateTime myDateTime = myTimeStamp.toDate();
                    print(myDateTime);
                    if (FeedbackDescData.isEmpty) {
                      final message = 'Enter Feedback Description';
                      Fluttertoast.showToast(msg: message, fontSize: 18);
                      //Navigator.of(context).pop();
                    } else {
                      feedbackProvider provider =
                          Provider.of(context, listen: false);
                      // UserProvider userProvider = Provider.of(context);

                      provider.addFeedbackData(
                          FeedbackDesc: FeedbackDescData,
                          Timestamp: myDateTime.toString());

                      var snackbar = const SnackBar(
                          content: Text('Feedback Send Successfully...'));
                      FeedbackDesc.text = '';
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  late feedbackProvider provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(9, 26, 46, 1),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(9, 26, 46, 1),
          shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(0),
          title: const Text(
            "Feedback",
            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          child: const Icon(Icons.add),
          backgroundColor: Color.fromRGBO(255, 207, 96, 1),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
