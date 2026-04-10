import 'package:flutter/material.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/screen/login_screen.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:geo_leaf/widgets/input/password_box.dart';
import 'package:geo_leaf/widgets/logo_widget.dart';
import 'package:geo_leaf/widgets/plant_box.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    final logPr = Provider.of<LoginProvider>(context);

    String name = "";
    String email = "";
    String password = "";
    String confirmPassword = "";

    return Scaffold(
      appBar: AppBar(),
      body: PlantBox(
        margin: EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              children: [
                LogoWidget(inBottom: true, width: 128, height: 128),

                Text(
                  "Crie sua conta",
                  style: TextStyle( fontSize: 25),
                ),
                TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(labelText: "Nome"),
                ),
                TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(labelText: "Email"),
                ),
                PasswordBox(
                  text: "Senha",
                  onChanged: (value) {
                    password = value;
                  },
                ),
                PasswordBox(
                  text: "Confirme sua senha",
                  onChanged: (value) {
                    confirmPassword = value;
                  },
                ),

                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.green),
                      ),
                      onPressed: () {
                        if (password == confirmPassword) {
                          _criarConta(context, {
                            "_id": Uuid().v4(),
                            "username": name,
                            "email": email,
                            "password": password,
                          }, logPr);
                        }
                      },
                      child: Text("Criar conta"),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancelar"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _criarConta(
    BuildContext context,
    Map<String, String> data,
    LoginProvider logPr,
  ) async {
    print(data);
    final user = await signupUser(data);
    if (user == null && context.mounted) {
      showDialog(
        context: context,
        builder: (_) => PlantBox(
          margin: EdgeInsets.symmetric(horizontal: 120, vertical: 256),
          child: Stack(
            children: [
              Align(
                child: Material(
                  child: Text(
                    "Deu algum erro",
                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (user != null && context.mounted) {
      logPr.logged = user;
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (bl) {
            return LoginScreen();
          },
        ),
      );
    }
  }
}
