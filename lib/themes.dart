import 'package:flutter/material.dart';

///主题设置
class WanTheme {
  final String name;
  final ThemeData data;

  WanTheme(this.name, this.data);
}

final WanTheme darkTheme = WanTheme('Dark', _buildDarkTheme());
final WanTheme lightTheme = WanTheme('Dark', _buildLightTheme());

///文字样式
TextTheme _buildTextTheme(TextTheme base) {
  return base;
}

///Dark主题
ThemeData _buildDarkTheme() {
  const Color primaryColor = Color(0xFF263238);
  const Color secondaryColor = Color(0xFF607D8B);
  final ThemeData base = ThemeData.dark();
  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  return base.copyWith(
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    accentColor: secondaryColor,
    canvasColor: const Color(0xFF202124),
    scaffoldBackgroundColor: const Color(0xFF202124),
    backgroundColor: const Color(0xFF202124),
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

///Light主题
ThemeData _buildLightTheme() {
  const Color primaryColor = Color(0xFF0097A7);
  const Color secondaryColor = Color(0xFF00BCD4);
  final ThemeData base = ThemeData.light();
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  return base.copyWith(
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    accentColor: secondaryColor,
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}
