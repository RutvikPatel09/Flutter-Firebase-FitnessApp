import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // List searchResult = [];

  // void searchCategory(String query) async {
  //   final result = await FirebaseFirestore.instance
  //       .collection('healthyFood')
  //       .where('foodName', isEqualTo: query)
  //       .get();

  //   setState(() {
  //     searchResult = result.docs.map((e) => e.data()).toList();
  //     //print(searchResult);
  //   });
  // }

  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 26, 46, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(9, 26, 46, 1),
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection("healthyFood").snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.docs[index].data()
                        as Map<String, dynamic>;

                    if (name.isEmpty) {
                      return ListTile(
                        title: Text(
                          data['foodName'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          data['Category'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data['image']),
                        ),
                      );
                    }
                    if (data['foodName']
                        .toString()
                        .toLowerCase()
                        .startsWith(name.toLowerCase())) {
                      return ListTile(
                        title: Text(
                          data['foodName'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          data['Category'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data['image']),
                        ),
                      );
                    }
                    return Container();
                  });
        },
      ),
      // appBar: AppBar(
      //     iconTheme: const IconThemeData(color: Colors.black),
      //     backgroundColor: dashboardColors[10],
      //     shadowColor: dashboardColors[10].withAlpha(0),
      //     title: const Text(
      //       "Search Food",
      //       style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
      //     )),
      // body: Padding(
      //   padding: EdgeInsets.all(16),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text("Search for a Food"),
      //       SizedBox(height: 20.0),
      //       TextField(
      //         onChanged: (value) => searchCategory(value),
      //         decoration: InputDecoration(
      //             filled: true,
      //             border: OutlineInputBorder(
      //                 borderRadius: BorderRadius.circular(8.0),
      //                 borderSide: BorderSide.none),
      //             hintText: "eg: Rice",
      //             prefixIcon: Icon(Icons.search),
      //             prefixIconColor: Colors.purple.shade900),
      //       ),
      //       SizedBox(
      //         height: 20.0,
      //       ),
      //       Expanded(
      //           child: searchResult.length == 0 ? Center(child: Text("No Result Found",
      //           style: TextStyle(color: Colors.black,fontSize: 22.0,fontWeight: FontWeight.bold),),):
      //           ListView.builder(
      //               itemCount: searchResult.length,
      //               itemBuilder: (context, index) {
      //                 return ListTile(
      //                   title: Text(searchResult[index]['foodName']),
      //                   trailing: SizedBox(
      //                     width: 100,
      //                     child: Row(
      //                       children: [
      //                         IconButton(
      //                             onPressed: () {}, icon: Icon(Icons.edit)),
      //                         IconButton(
      //                             onPressed: () {}, icon: Icon(Icons.delete))
      //                       ],
      //                     ),
      //                   ),
      //                 );
      //               })
      //        )
      //     ],
      //   ),
      // )
    );
  }
}
