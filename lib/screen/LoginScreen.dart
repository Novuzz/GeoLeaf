import 'package:flutter/material.dart';
import 'package:geo_leaf/screen/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("RA"),
            TextField(),
            Text("Senha"),
            TextField(),
            FloatingActionButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder:  (_) => HomeScreen())))
          ],
        ),
      ),
    );
  }
}