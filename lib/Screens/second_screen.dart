import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/Model/Student_model.dart';
import 'package:firebase_login/Model/studentwidget.dart';
import 'package:firebase_login/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class detailScreen extends StatefulWidget {
  const detailScreen({Key? key}) : super(key: key);

  @override
  State<detailScreen> createState() => _detailScreenState();
}

class _detailScreenState extends State<detailScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController scoreController = TextEditingController();
  List<String> docIds = [];
  final CollectionReference _student =
      FirebaseFirestore.instance.collection('ETEC');
  Future getDocID() async {
    await FirebaseFirestore.instance
        .collection('ETEC')
        .get()
        .then((value) => value.docs.forEach((element) {
              print('DocID=${element.reference.id}');
              docIds.add(element.reference.id);
            }));
  }

  Future createStudent({Student? student}) async {
    try {
      var studentdoc = FirebaseFirestore.instance.collection('ETEC').doc();
      final json = student!.toJson();
      await studentdoc.set(json);
    } catch (e) {
      print(e);
    }
  }

  var firedata;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firedata = getDocID();
    idController.text = Random().nextInt(100).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance
                    .signOut()
                    .whenComplete(() => messagelogout());
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: idController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: const Text(
                          'Auto ID',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: genderController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter gender',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: scoreController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter Score',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            width: double.infinity,
            child: FutureBuilder(
              future: firedata,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Icon(
                      Icons.info,
                      size: 30,
                      color: Colors.red,
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: docIds.length,
                  itemBuilder: (context, index) {
                    return StudentWidget(documentId: docIds[index]);
                  },
                );
              },
            ),
          ))
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: CupertinoButton(
              color: Colors.red,
              child: const Text('clear'),
              onPressed: () {
                setState(() {
                  idController.text = Random().nextInt(100).toString();
                  nameController.text = '';
                  genderController.text = '';
                  scoreController.text = '';
                });
              },
            ),
          ),
          Expanded(
            child: CupertinoButton(
              color: Theme.of(context).primaryColor,
              child: const Text('save'),
              onPressed: () async {
                await createStudent(
                        student: Student(
                            id: int.parse(idController.text),
                            name: nameController.text,
                            gender: genderController.text,
                            score: double.parse(scoreController.text)))
                    .whenComplete(() {
                  setState(() {
                    docIds.clear();
                    firedata = getDocID();
                  });
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> messagelogout() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Do yo want to signout ?'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance
                      .signOut()
                      .whenComplete(() => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyHomePage(),
                          ),
                          (route) => false));
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }
}
