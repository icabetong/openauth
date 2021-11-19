import 'package:flutter/material.dart';
import 'package:openauth/theme/core.dart';

ThemeData getDefault({Brightness brightness = Brightness.light}) {
  ThemeData base = getBase(brightness: brightness);
  final primary = Colors.teal.shade500;
  const onPrimary = Colors.white;
  final scaffold = brightness == Brightness.light
      ? base.colorScheme.surface
      : base.scaffoldBackgroundColor;

  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: base.colorScheme.surface,
        titleTextStyle: base.appBarTheme.titleTextStyle
            ?.copyWith(color: base.colorScheme.onSurface)),
    scaffoldBackgroundColor: scaffold,
    colorScheme: base.colorScheme.copyWith(
      primary: primary,
      onPrimary: onPrimary,
      secondary: primary,
      onSecondary: onPrimary,
    ),
  );
}
