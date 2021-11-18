import 'package:flutter/material.dart';
import 'package:openauth/theme/core.dart';

ThemeData getAmoled() {
  final base = getBase(brightness: Brightness.dark);

  final primary = Colors.teal[500];
  const onPrimary = Color(0xffffffff);
  const background = Color(0xff000000);

  return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: base.colorScheme.copyWith(
          primary: primary,
          onPrimary: onPrimary,
          surface: background,
          onSurface: Colors.white));
}
