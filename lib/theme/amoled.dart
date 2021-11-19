import 'package:flutter/material.dart';
import 'package:openauth/theme/core.dart';

ThemeData getAmoled() {
  final base = getBase(brightness: Brightness.dark);

  final primary = Colors.teal[500];
  const onPrimary = Color(0xffffffff);
  const background = Color(0xff080808);
  const surface = Color(0xff1c1c1c);

  return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: base.colorScheme.copyWith(
          primary: primary,
          onPrimary: onPrimary,
          secondary: primary,
          onSecondary: onPrimary,
          surface: surface,
          onSurface: Colors.white),
      bottomAppBarColor: surface,
      popupMenuTheme: base.popupMenuTheme
          .copyWith(color: Color.lerp(surface, Colors.white, 0.05)));
}
