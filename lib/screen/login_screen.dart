import 'package:flutter/material.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/screen/map_screen.dart';
import 'package:geo_leaf/screen/signup_screen.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:geo_leaf/widgets/input/password_box.dart';
import 'package:geo_leaf/widgets/logo_widget.dart';
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
        margin: EdgeInsets.all(16),

        child: Align(
          alignment: AlignmentGeometry.center,
          child: Stack(
            children: [
              Column(
                children: [
                  LogoWidget(inBottom: true, width: 128, height: 128),
                  SizedBox(height: 32),
                  Text("Entre em sua conta", style: TextStyle(fontSize: 25)),

                  SizedBox(height: 20),

                  TextField(
                    onChanged: (value) {
                      email = value;
                    },

                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  PasswordBox(
                    onChanged: (value) {
                      password = value;
                    },
                    text: "Senha",
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
                  SizedBox(height: 4),
                  TextButton(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _enterAccount(LoginProvider login) async {
    final user = await loginUser("char@gmail.com", "4321");
    //final user = await loginUser(email, password);

    if (user != null && mounted) {
      setState(() {
        login.logged = user;
        print(login.logged!.username);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (bl) {
              return MapScreen();
            },
          ),
        );
      });
    }
  }
}
