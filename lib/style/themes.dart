import 'package:flutter/material.dart';

final _primaryColor = Colors.orange;

final kTheme = ThemeData(
  primaryColor: _primaryColor,
  accentColor: Colors.orangeAccent[400],
  buttonColor: _primaryColor,
  indicatorColor: Colors.white,
  canvasColor: Colors.white,
  primaryColorBrightness: Brightness.dark,
  accentColorBrightness: Brightness.dark,
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.0),
    ),
  ),
);
