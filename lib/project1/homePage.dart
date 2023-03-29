import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_datalist/project1/auth/phone.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference donor =
      FirebaseFirestore.instance.collection('donor');

  void deleteDonor(docId) {
    donor.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 52, 48),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.defaultDialog(
                  title: 'LogOut',
                  middleText: 'Are you sure???',
                  textConfirm: 'Yes',
                  textCancel: 'No',
                  onConfirm: () {
                    FirebaseAuth.instance.signOut();
                    Get.snackbar('Success', 'You have logged out successfully',
                        snackPosition: SnackPosition.BOTTOM);
                    Navigator.pushNamed(context, '/');
                  });
            },
            icon: const Icon(Icons.logout)),
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 11, 52, 48),
        actions: [
          Card(
            color: const Color.fromARGB(255, 11, 52, 48),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
              icon: const Icon(
                Icons.add,
              ),
            ),
          )
        ],
        title: const Text(
          'Blood Donation App',
          style: TextStyle(fontWeight: FontWeight.w200, fontSize: 23),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white30,
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/add');
      //   },
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder(
        stream: donor.orderBy('name').snapshots(), //datas in database
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.docs.length == 0
                ? const Center(
                    child: Text(
                    'No data',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 28,
                        fontWeight: FontWeight.w100),
                  ))
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot donorSnap =
                          snapshot.data.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            //set border radius more than 50% of height and width to make circle
                          ),
                          color: Colors.white24,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 80,
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white54,
                                        radius: 28,
                                        child: Text(
                                          donorSnap['group'] ?? '',
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        donorSnap['name'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        donorSnap['phone'].toString(),
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/update',
                                            arguments: {
                                              'name': donorSnap['name'],
                                              'phone':
                                                  donorSnap['phone'].toString(),
                                              'group': donorSnap['group'],
                                              'id': donorSnap.id,
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.edit),
                                        iconSize: 25,
                                        color: Colors.white70,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // deleteDonor(donorSnap.id);
                                          showAlertDialog(donorSnap.id);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                        ),
                                        iconSize: 25,
                                        color: Colors.white70,
                                      ),
                                    ],
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
          return Container();
        },
      ), //build widgets
    );
  }

  //show dialogue
  void showAlertDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete?'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                deleteDonor(id);
                Navigator.pop(context);
                Get.snackbar('Success', 'Data deleted successfully',
                    snackPosition: SnackPosition.BOTTOM);
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );
  }
}
