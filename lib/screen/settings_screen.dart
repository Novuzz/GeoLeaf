import 'package:flutter/material.dart';
import 'package:geo_leaf/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool ch = false;
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    setState(() {
      ch = theme.darkTheme;
    });
    return Scaffold(
      appBar: AppBar(title: Text("Configurações"), centerTitle: true),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _container(
              "Modo Noturno",
              Checkbox(
                value: ch,
                onChanged: (value) {
                  setState(() {
                    ch = value!;
                    theme.setDarkTheme(value);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _container(String name, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(name, style: TextStyle(fontSize: 24)),
        SizedBox(width: 32),
        child,
      ],
    );
  }
}
