import 'package:flutter/material.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/screen/home_screen.dart';
import 'package:geo_leaf/screen/signup_screen.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:geo_leaf/widgets/plant_box.dart';
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
      body: PlantBox(
        margin: EdgeInsets.all(90),

        child: Stack(
          children: [
            Column(
              children: [
                Text(
                  "Insira seus dados abaixo",
                  style: TextStyle(fontSize: 25),
                ),

                SizedBox(height: 20),

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
                const SizedBox(height: 15),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green),
                  ),
                  child: Text(
                    "Entrar",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onPressed: () => _enterAccount(login),
                ),
              ],
            ),
            Align(
              alignment: AlignmentGeometry.bottomLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignupScreen()),
                  );
                },
                child: Text(
                  "criar conta",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _enterAccount(LoginProvider login) async {
    final user = await loginUser("te22t@hotmail.com", "12ewews");
    if (user != null && mounted) {
      setState(() {
        login.logged = user;
        print(login.logged!.username);
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
  }
}
