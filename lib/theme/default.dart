import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/settings/provider.dart';

String getThemeName(BuildContext context, UserTheme theme) {
  switch (theme) {
    case UserTheme.light:
      return Translations.of(context)!.settings_theme_light;
    case UserTheme.dark:
      return Translations.of(context)!.settings_theme_dark;
  }
}

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

  return base.copyWith(
      appBarTheme: base.appBarTheme,
      bottomAppBarTheme: base.bottomAppBarTheme.copyWith(elevation: 12),
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
      ));
}
