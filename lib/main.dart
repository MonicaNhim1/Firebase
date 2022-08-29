import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login/Screens/createNewUser_screen.dart';
import 'package:firebase_login/Screens/second_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth au = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Login Account'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter Emial',
                      prefixIcon: const Icon(Icons.email)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Enter password',
                    prefixIcon: const Icon(Icons.key),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var status = await signInAccount(
                        emailController.text.trim(),
                        passwordController.text.trim());
                    if (status == '200') {
                      setState(() {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const detailScreen(),
                            ),
                            (route) => false);
                      });
                    } else {
                      print(status);
                    }
                  },
                  child: Container(
                      width: 330,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                          child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )))),
              TextButton(
                  onPressed: () {}, child: const Text('Forgotten password')),
              const SizedBox(
                height: 30,
              ),
              Container(
                  width: 200,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return CreateNewUser();
                          },
                        ));
                      },
                      child: const Text(
                        'Create New Account',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ))),
            ],
          ),
        ));
  }

  Future<String> signInAccount(String email, String password) async {
    String message = 'Error';
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      message = '200';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          message = e.code;
          break;
        case 'invalid-password':
          message = e.code;
          break;
        case 'wrong-password':
          message = e.code;
          break;
        case 'user-not-found':
          message = e.code;
          break;
      }
    }
    return message;
  }
}
