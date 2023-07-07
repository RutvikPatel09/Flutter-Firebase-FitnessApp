import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:video_player/video_player.dart';

import 'listItem.dart';

class showVideos extends StatefulWidget {
  const showVideos({super.key});

  @override
  State<showVideos> createState() => _showVideosState();
}

class _showVideosState extends State<showVideos> {
  CollectionReference videos =
      FirebaseFirestore.instance.collection("addExerciseVideos");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(9, 26, 46, 1),
        shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(0),
        title: const Text(
          "Workout Videos",
          style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(9, 26, 46, 1),
        child: StreamBuilder(
            stream: videos.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                // return GridView.builder(
                //   itemCount: streamSnapshot.data!.docs.length,
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     // childAspectRatio: 1.0,
                //     // crossAxisSpacing: 0.0,
                //     // mainAxisSpacing: 5,
                //     // mainAxisExtent: 150,
                //   ),
                return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];

                      return Column(
                        children: [
                          Container(
                              width: 410,
                              height: 230,
                              child: listItem(
                                videoPlayerController:
                                    VideoPlayerController.network(
                                  documentSnapshot['videoUrl'],
                                ),
                                looping: true,
                              )),
                          Text(
                            " " + documentSnapshot['videoName'],
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      );
                    });
                //);
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
