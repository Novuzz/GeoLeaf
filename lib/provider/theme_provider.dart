import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool darkTheme = false;
  ThemeData theme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.green,
      onPrimary: Colors.black,
      secondary: Colors.lightGreen,
      onSecondary: Colors.greenAccent,
      error: Colors.greenAccent,
      onError: Colors.greenAccent,
      surface: Colors.black,
      onSurface: Colors.green,
    ),
  );

  void setDarkTheme(bool value) {
    darkTheme = value;
    theme = ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Colors.green,
        onPrimary: value ? Colors.black : Colors.white,
        secondary: Colors.lightGreen,
        onSecondary: Colors.greenAccent,
        error: Colors.greenAccent,
        onError: Colors.greenAccent,
        surface: value ? Colors.black : Colors.white,
        onSurface: Colors.green,
      ),
    );
    notifyListeners();
  }
}
