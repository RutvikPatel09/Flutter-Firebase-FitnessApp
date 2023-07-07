import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:supreme_fitness/providers/trainerProvider.dart';
import 'package:uuid/uuid.dart';

class addTrainer extends StatefulWidget {
  const addTrainer({super.key});

  @override
  State<addTrainer> createState() => _addTrainerState();
}

class _addTrainerState extends State<addTrainer> {
  final TextEditingController trainername = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();

  void clearText() {
    phone.clear();
  }

  CollectionReference trainers =
      FirebaseFirestore.instance.collection("addTrainer");

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
                  controller: trainername,
                  decoration: const InputDecoration(labelText: "Trainer Name"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(labelText: "Phone Number"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email Address"),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Add'),
                  style: ElevatedButton.styleFrom(primary: Color(0xff4c505b)),
                  onPressed: () {
                    final String trainerName = trainername.text;
                    final String Phone = phone.text;
                    final String Email = email.text;
                    //const uuid = Uuid();
                    //final String Code = uuid.v1();
                    Random random = new Random();
                    int randomNumber = random.nextInt(100);

                    if (trainerName.isEmpty) {
                      var snackbar = SnackBar(
                          content: Text('Enter Trainer Name to Submit!!!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      Navigator.of(context).pop();
                    } else {
                      trainerProvider provider =
                          Provider.of(context, listen: false);
                      // UserProvider userProvider = Provider.of(context);

                      provider.addTrainer(
                          trainerName: trainerName,
                          Phone: Phone,
                          Email: Email,
                          Code: trainerName + randomNumber.toString());

                      var snackbar = SnackBar(
                          content: Text('Trainer Added Successfully...'));
                      trainername.text = '';
                      clearText();
                      email.text = '';
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

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      trainername.text = documentSnapshot['trainerName'];
      email.text = documentSnapshot['Email'];
      phone.text = documentSnapshot['Phone'];
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
                  controller: trainername,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(labelText: "Phone Number"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email Address"),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String trainerName = trainername.text;
                    final String Phone = phone.text;
                    final String Email = email.text;
                    if (trainername != null) {
                      await trainers.doc(documentSnapshot!.id).update({
                        "trainerName": trainerName,
                        "Phone": Phone,
                        "Email": Email
                      });
                      trainername.text = '';
                      clearText();
                      email.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String Id) async {
    await trainers.doc(Id).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a Trainer')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: dashboardColors[10],
          shadowColor: dashboardColors[10].withAlpha(0),
          title: const Text(
            "Manage Trainer",
            style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
          ),
        ),
        body: StreamBuilder(
            stream: trainers.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return GridView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // childAspectRatio: 1.0,
                    // crossAxisSpacing: 0.0,
                    // mainAxisSpacing: 5,
                    // mainAxisExtent: 150,
                  ),
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];

                    return SingleChildScrollView(
                        child: Card(
                            margin: const EdgeInsets.all(12),
                            child: Container(
                              margin: const EdgeInsets.all(14),

                              // child: ListTile(
                              //   title: Text(
                              //     documentSnapshot['policeID'],
                              //   ),
                              child: Column(children: [
                                Text(
                                  "Name: " + documentSnapshot['trainerName'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Phone: " + documentSnapshot['Phone']),
                                ),
                                Text("Email: " +
                                    documentSnapshot['Email'].toString()),
                                SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () =>
                                            _update(documentSnapshot),
                                      ),
                                      IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  child: AlertDialog(
                                                    title: Text(
                                                        "Are You Sure You Want to Delete the Trainer?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("NO")),
                                                      TextButton(
                                                          onPressed: () {
                                                            _delete(
                                                                documentSnapshot
                                                                    .id);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("YES"))
                                                    ],
                                                  ),
                                                );
                                              }))
                                    ],
                                  ),
                                ),
                              ]),
                            )));
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          backgroundColor: Color(0xff4c505b),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
