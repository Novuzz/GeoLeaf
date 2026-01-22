import 'package:flutter/material.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/screen/HomeScreen.dart';
import 'package:geo_leaf/utils/HttpRequest.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";


  @override
  Widget build(BuildContext context) {
  var login = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Email"),
            TextField(
              onChanged: (value) {
                email = value;
              },
            ),
            Text("Senha"),
            TextField(
              onChanged: (value) {
                password = value;
              },
            ),
            FloatingActionButton(
              onPressed: () async {
                final user = await loginUser(email, password);
                if (user != null && mounted) {
                  setState(() {
                    login.logged = user;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (bl) {
                          return HomeScreen();
                        },
                      ),
                    );
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
