import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/settings/provider.dart';
import 'package:flutter/material.dart';
import 'package:openauth/theme/amoled.dart';
import 'package:openauth/theme/default.dart';
import 'package:openauth/theme/dracula.dart';
import 'package:openauth/theme/nord.dart';

String getThemeName(BuildContext context, UserTheme theme) {
  switch (theme) {
    case UserTheme.light:
      return Translations.of(context)!.settings_theme_light;
    case UserTheme.dark:
      return Translations.of(context)!.settings_theme_dark;
    case UserTheme.amoled:
      return Translations.of(context)!.settings_theme_amoled;
    case UserTheme.dracula:
      return Translations.of(context)!.settings_theme_dracula;
    case UserTheme.nord:
      return Translations.of(context)!.settings_theme_nord;
  }
}

ThemeData getTheme(UserTheme userTheme) {
  switch (userTheme) {
    case UserTheme.light:
      return getDefault();
    case UserTheme.dark:
      return getDefault(brightness: Brightness.dark);
    case UserTheme.amoled:
      return getAmoled();
    case UserTheme.dracula:
      return getDracula();
    case UserTheme.nord:
      return getNord();
  }
}

ThemeData getBase({Brightness brightness = Brightness.light}) {
  final base = ThemeData(brightness: brightness, fontFamily: 'Outfit');

  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(elevation: 2),
    bottomAppBarTheme: base.bottomAppBarTheme.copyWith(elevation: 12),
  );
}
