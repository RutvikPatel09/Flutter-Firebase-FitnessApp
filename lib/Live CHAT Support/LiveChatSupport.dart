import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';

class LiveChatSupport extends StatefulWidget {
  const LiveChatSupport({super.key});

  @override
  State<LiveChatSupport> createState() => _LiveChatSupportState();
}

class _LiveChatSupportState extends State<LiveChatSupport> {
  var Name;
  var Email;

  void getCurrentData() async {
    User? user = await FirebaseAuth.instance.currentUser;
    String? getemail = user?.email;

    setState(() {
      Email = getemail!;
    });
    print(getemail);
  }

  void getData() async {
    CollectionReference collectionReference1 = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("profileData");

    // CollectionReference collectionReference2 =
    //     FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid);

    QuerySnapshot querySnapshot1 = await collectionReference1.get();
    // QuerySnapshot querySnapshot2 = await collectionReference2.get();
    final name = querySnapshot1.docs.map((doc) => doc['userName']).toList();

    String nameToString = name.join();
    //String emailToString = email.join();

    setState(() {
      Name = nameToString;
      //Email = emailToString;
    });
    print("Data:- " + nameToString);
  }

  @override
  void initState() {
    super.initState();
    getCurrentData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromRGBO(9, 26, 46, 1),
      appBar: AppBar(
        title: const Text('Supreme Fitness Support'),
        backgroundColor: Color.fromRGBO(9, 26, 46, 1),
        shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(0),
        elevation: 0,
      ),
      body: Tawk(
        directChatLink:
            'https://tawk.to/chat/640d60ea4247f20fefe55dfa/1gra455n4',
        visitor: TawkVisitor(
          name: Name,
          email: Email,
        ),
        onLoad: () {
          print('Hello Tawk!');
        },
        onLinkTap: (String url) {
          print(url);
        },
        placeholder: const Center(
          child: Text('Loading...'),
        ),
      ),
    );
  }
}
