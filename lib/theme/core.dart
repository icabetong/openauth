import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/settings/provider.dart';
import 'package:flutter/material.dart';
import 'package:openauth/theme/amoled.dart';
import 'package:openauth/theme/default.dart';
import 'package:openauth/theme/dracula.dart';
import 'package:openauth/theme/nord.dart';
import 'package:openauth/theme/sunset.dart';

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
    case UserTheme.sunset:
      return Translations.of(context)!.settings_theme_sunset;
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
    case UserTheme.sunset:
      return getSunset();
  }
}

ThemeData getBase({Brightness brightness = Brightness.light}) {
  const font = 'Rubik';
  final base = ThemeData(brightness: brightness, fontFamily: font);

  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(
        elevation: 2,
        titleTextStyle: TextStyle(
            fontFamily: font,
            color: base.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
            fontSize: 20),
        iconTheme: IconThemeData(color: base.colorScheme.onSurface)),
    bottomAppBarTheme: base.bottomAppBarTheme.copyWith(elevation: 12),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}
