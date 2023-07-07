import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:supreme_fitness/providers/profileDataProvider.dart';

import '../providers/userProvider.dart';

// ignore: must_be_immutable
class MyProfile extends StatefulWidget {
  //const MyProfile({super.key});
  profileDataProvider profileProvider;
  MyProfile({required this.profileProvider});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final TextEditingController Name = TextEditingController();
  final TextEditingController Surname = TextEditingController();
  final TextEditingController Phone = TextEditingController();

  late String ids;


  CollectionReference user = FirebaseFirestore.instance.collection("users");


  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      Name.text = documentSnapshot['userName'];
      Surname.text = documentSnapshot['userSurname'];
      Phone.text = documentSnapshot['userPhone'];
    }

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
                  controller: Name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: Surname,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Surname"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: Phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(labelText: "Phone Number"),
                ),
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
                    final String name = Name.text;
                    final String surname = Surname.text;
                    final String phone = Phone.text;

                    if (name.isEmpty) {
                      final message = 'Enter Name';
                      Fluttertoast.showToast(msg: message, fontSize: 18);
                      //Navigator.of(context).pop();
                    } else if (surname.isEmpty) {
                      final message = 'Enter Surname';
                      Fluttertoast.showToast(msg: message, fontSize: 18);
                    } else if (phone.toString().isEmpty) {
                      final message = 'Enter Phone';
                      Fluttertoast.showToast(msg: message, fontSize: 18);
                    } else {
                      profileDataProvider provider =
                          Provider.of(context, listen: false);
                      // UserProvider userProvider = Provider.of(context);

                      provider.subCollection(
                          userName: name,
                          userSurname: surname,
                          userPhone: phone);

                      var snackbar = const SnackBar(
                          content: Text('User Details Updated...'));
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

  void getData() async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("profileData");

    QuerySnapshot querySnapshot = await collectionReference.get();
    final data = querySnapshot.docs.map((doc) => doc.data()).toList();
    final name = querySnapshot.docs.map((doc) => doc['userName']).toList();
    // final FirebaseAuth auth = FirebaseAuth.instance;
    // final User user = auth.currentUser?.uid as User;
    // print(user);

    String nameToString = name.join();

    setState(() {
      Name.text = nameToString;
    });

    //print(name);
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
                  controller: Name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(255, 207, 96, 1)),
                  onPressed: () async {
                    final String name = Name.text;
                    final _auth = FirebaseAuth.instance;
                    var uid = _auth.currentUser?.uid;

                    var collection =
                        FirebaseFirestore.instance.collection('users');

                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection("profileData")
                        .get()
                        .then((value) => value.docs.forEach((element) {
                              print(element.id);
                            }));

                    collection
                        .doc(uid)
                        .collection("profileData")
                        .doc(ids)
                        .update({'userName': name}) // <-- Nested value
                        .then((_) => print('Success'))
                        .catchError((error) => print('Failed: $error'));

                    Navigator.of(context).pop();
                    // if (name != null) {
                    //   CollectionReference collectionReference =
                    //       FirebaseFirestore.instance.collection("users");
                    //   await user
                    //       .doc(FirebaseAuth.instance.currentUser?.uid).collection("profileData").doc(FirebaseAuth.instance.currentUser?.uid)
                    //       .update({"userName": name});
                    // }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    //var data = await FirebaseFirestore.instance
    //   .collection('users')
    //  .doc(FirebaseAuth.instance.currentUser?.uid);
    // .collection('profileData')
    // .doc(FirebaseAuth.instance.currentUser?.uid)
    // .get();
    //  print(data);

    // if (documentSnapshot != null) {
    //   Name.text = documentSnapshot['userName'];
    // }
    // await showModalBottomSheet(
    //     isScrollControlled: true,
    //     context: context,
    //     builder: (BuildContext ctx) {
    //       return Padding(
    //         padding: EdgeInsets.only(
    //             top: 20,
    //             left: 20,
    //             right: 20,
    //             bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             TextField(
    //               controller: Name,
    //               decoration: const InputDecoration(labelText: 'Name'),
    //             ),
    //             const SizedBox(
    //               height: 20,
    //             ),
    //             ElevatedButton(
    //               child: const Text('Update'),
    //               onPressed: () async {
    //                 final String name = Name.text;
    //                 if (name != null) {
    //                   await profileData
    //                       .doc(FirebaseAuth.instance.currentUser?.uid)
    //                       .update({"userName": name});
    //                   Name.text = '';
    //                   Navigator.of(context).pop();
    //                 }
    //               },
    //             )
    //           ],
    //         ),
    //       );
    //     });
  }

  @override
  Widget build(BuildContext context) {
    //profileDataProvider profileProvider = Provider.of(context);
    //profileProvider.getUserData();
    //var userData = profileProvider.currentUserData;
    
    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 26, 46, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(9, 26, 46, 1),
        shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(0),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("profileData")
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    snapshot.data!.docs[index];

                ids = documentSnapshot.id;
                //print(ids);

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 98.0),
                    child: Card(
                      color: Color.fromRGBO(59, 72, 89, 1),
                      clipBehavior: Clip.antiAlias,
                      shadowColor: dashboardColors[10].withAlpha(0),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 158.0),
                              child: const Image(
                                height: 90,
                                width: 140,
                                image: NetworkImage(
                                    "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                              ),
                            ),
                            ListTile(
                              title: SizedBox(
                                  width: 25,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "Name:- " +
                                              documentSnapshot['userName'],
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "Surname:- " +
                                              documentSnapshot['userSurname'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "Phone:- " +
                                              "+91" +
                                              " " +
                                              "|" +
                                              " " +
                                              documentSnapshot['userPhone'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            IconButton(
                              icon: Icon(Icons.update),
                              iconSize: 50,
                              color: Colors.white,
                              tooltip: 'Update',
                              onPressed: () {
                                getData();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _create,
        backgroundColor: Color.fromRGBO(255, 207, 96, 1),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
