import 'package:flutter/material.dart';
import 'package:openauth/theme/core.dart';

ThemeData getSunset() {
  final base = getBase(brightness: Brightness.dark);

  const primary = Color(0xfffa8830);
  const onPrimary = Color(0xff000000);
  const surface = Color(0xff082336);
  final background = Color.lerp(surface, Colors.black, 0.5);

  return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        onPrimary: onPrimary,
        secondary: primary,
        onSecondary: onPrimary,
        surface: surface,
      ),
      bottomAppBarTheme: base.bottomAppBarTheme.copyWith(color: surface),
      popupMenuTheme: base.popupMenuTheme.copyWith(color: surface),
      bottomSheetTheme:
          base.bottomSheetTheme.copyWith(backgroundColor: surface));
}
