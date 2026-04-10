import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool darkTheme = false;
  ThemeData theme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xFF2BAD31),
      onPrimary: Colors.white,
      secondary: Colors.lightGreen,
      onSecondary: Colors.greenAccent,
      error: Colors.greenAccent,
      onError: Colors.greenAccent,
      surface: Colors.white,
      onSurface: const Color(0xFF2BAD31),
    ),
  );

  void setDarkTheme(bool value) {
    darkTheme = value;
    theme = ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: const Color(0xFF2BAD31),
        onPrimary: value ? Colors.black : Colors.white,
        secondary: Colors.lightGreen,
        onSecondary: Colors.greenAccent,
        error: Colors.greenAccent,
        onError: Colors.greenAccent,
        surface: value ? Colors.black : Colors.white,
        onSurface: const Color(0xFF2BAD31),
      ),
    );
    notifyListeners();
  }
}
