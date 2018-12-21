import 'package:flutter/material.dart';

///主题设置
class WanTheme {
  final String name;
  final ThemeData data;

  WanTheme(this.name, this.data);
}

final WanTheme darkTheme = WanTheme('Dark', _buildDarkTheme());
final WanTheme lightTheme = WanTheme('默认',
    _buildLightTheme(Color(0xFF0097A7), Color(0xFF0097A7), Color(0xFF00ACC1)));
final WanTheme anyuziTheme = WanTheme('暗玉紫',
    _buildLightTheme(Color(0xFF5c2223), Color(0xFF5c2223), Color(0xFF5c2223)));
final WanTheme xiaguanghongTheme = WanTheme('霞光红',
    _buildLightTheme(Color(0xFFef82a0), Color(0xFFef82a0), Color(0xFFef82a0)));
final WanTheme fengyehongTheme = WanTheme('枫叶红',
    _buildLightTheme(Color(0xFFc21f30), Color(0xFFc21f30), Color(0xFFc21f30)));
final WanTheme haitaolanTheme = WanTheme('海涛蓝',
    _buildLightTheme(Color(0xFF15559a), Color(0xFF15559a), Color(0xFF15559a)));
final WanTheme qingshanTheme = WanTheme('晴山蓝',
    _buildLightTheme(Color(0xFF8fb2c9), Color(0xFF8fb2c9), Color(0xFF8fb2c9)));
final WanTheme jinyehuangTheme = WanTheme('金叶黄',
    _buildLightTheme(Color(0xFFffa60f), Color(0xFFffa60f), Color(0xFFffa60f)));
final WanTheme bohelvTheme = WanTheme('薄荷绿',
    _buildLightTheme(Color(0xFF207f4c), Color(0xFF207f4c), Color(0xFF207f4c)));
final themes = [
  lightTheme,
  fengyehongTheme,
  xiaguanghongTheme,
  jinyehuangTheme,
  bohelvTheme,
  qingshanTheme,
  haitaolanTheme,
  anyuziTheme,
];

///文字样式
TextTheme _buildTextTheme(TextTheme base) {
  return base;
}

///Dark主题
ThemeData _buildDarkTheme() {
  const Color primaryColor = Color(0xFF263238);
  const Color secondaryColor = Color(0xFF607D8B);
  const Color primaryColorLight = Color(0xFF78909C);
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
    primaryColorLight: primaryColorLight,
  );
}

///Light主题
ThemeData _buildLightTheme(primaryColor, secondaryColor, primaryColorLight) {
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
    primaryColorLight: primaryColorLight,
  );
}
