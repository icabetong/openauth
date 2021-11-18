import 'package:flutter/material.dart';
import 'package:openauth/settings/provider.dart';

ThemeData getBase({Brightness brightness = Brightness.light}) {
  return ThemeData(brightness: brightness);
}

ThemeData getDefault(UserTheme theme) {
  ThemeData base = getBase(
      brightness:
          theme == UserTheme.light ? Brightness.light : Brightness.dark);
  const primary = Color(0xffffffff);
  const onPrimary = Color(0xff000000);
  final secondary = Colors.teal.shade500;
  const onSecondary = Colors.white;
  const scaffoldColor = Color(0xffffffff);

  return base.copyWith(
      appBarTheme: base.appBarTheme,
      bottomAppBarTheme: base.bottomAppBarTheme.copyWith(elevation: 12),
      scaffoldBackgroundColor: scaffoldColor,
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
      ));
}
