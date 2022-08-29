import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/main.dart';
import 'package:flutter/material.dart';

class detailScreen extends StatefulWidget {
  const detailScreen({Key? key}) : super(key: key);

  @override
  State<detailScreen> createState() => _detailScreenState();
}

class _detailScreenState extends State<detailScreen> {
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
