import 'package:flutter/material.dart';
import 'package:openauth/theme/core.dart';

ThemeData getDefault({Brightness brightness = Brightness.light}) {
  ThemeData base = getBase(brightness: brightness);
  const primary = Color(0xffffffff);
  const onPrimary = Color(0xff000000);
  final secondary = Colors.teal.shade500;
  const onSecondary = Colors.white;
  final scaffold = brightness == Brightness.light
      ? base.colorScheme.surface
      : base.scaffoldBackgroundColor;

  return base.copyWith(
    appBarTheme: base.appBarTheme,
    scaffoldBackgroundColor: scaffold,
    colorScheme: base.colorScheme.copyWith(
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
    ),
  );
}
