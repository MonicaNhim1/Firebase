import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreateNewUser extends StatelessWidget {
  const CreateNewUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController newUserController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController comfirmPasswordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new User'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                'New User \n Please Create your Account now',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: newUserController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  label: const Text('Enter Email'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  label: const Text('Enter Password'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: comfirmPasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  label: const Text('Comfirm Password'),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await createNewUserAccount(
                    newUserController.text.trim(),
                    newPasswordController.text.trim(),
                    comfirmPasswordController.text.trim());
              },
              child: const Text(
                'Create',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool Comfirmpassword(String password, String comfirmpassword) {
    if (password == comfirmpassword) {
      return true;
    } else {
      print('Not match password , check it again');
      return false;
    }
  }

  Future<void> createNewUserAccount(
      String email, String password, String comfirmpassword) async {
    if (Comfirmpassword(password, comfirmpassword)) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        print(e);
      }
    }
  }
}
