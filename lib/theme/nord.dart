import 'package:flutter/material.dart';
import 'package:openauth/theme/core.dart';

ThemeData getNord() {
  final base = getBase(brightness: Brightness.dark);

  const primary = Color(0xff8FBCBB);
  const onPrimary = Color(0xff000000);
  const background = Color(0xff2E3440);
  const surface = Color(0xff3B4252);
  const onSurface = Color(0xffffffff);

  return base.copyWith(
      scaffoldBackgroundColor: background,
      bottomAppBarColor: surface,
      colorScheme: base.colorScheme.copyWith(
          primary: primary,
          onPrimary: onPrimary,
          secondary: primary,
          onSecondary: onPrimary,
          surface: surface,
          onSurface: onSurface),
      popupMenuTheme: base.popupMenuTheme.copyWith(color: surface));
}
