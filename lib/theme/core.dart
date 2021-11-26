import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter/material.dart';
import 'package:openauth/theme/amoled.dart';
import 'package:openauth/theme/default.dart';
import 'package:openauth/theme/dracula.dart';
import 'package:openauth/theme/nord.dart';
import 'package:openauth/theme/sunset.dart';

enum AppTheme { light, dark, amoled, dracula, nord, sunset }

extension AppThemeExtension on AppTheme {
  String get value {
    switch (this) {
      case AppTheme.light:
        return 'light';
      case AppTheme.dark:
        return 'dark';
      case AppTheme.amoled:
        return 'amoled';
      case AppTheme.dracula:
        return 'dracula';
      case AppTheme.nord:
        return 'nord';
      case AppTheme.sunset:
        return 'sunset';
    }
  }

  static AppTheme parse(String theme) {
    switch (theme) {
      case 'light':
        return AppTheme.light;
      case 'dark':
        return AppTheme.dark;
      case 'amoled':
        return AppTheme.amoled;
      case 'dracula':
        return AppTheme.dracula;
      case 'nord':
        return AppTheme.nord;
      case 'sunset':
        return AppTheme.sunset;
      default:
        throw Error();
    }
  }
}

String getThemeName(BuildContext context, AppTheme theme) {
  switch (theme) {
    case AppTheme.light:
      return Translations.of(context)!.settings_theme_light;
    case AppTheme.dark:
      return Translations.of(context)!.settings_theme_dark;
    case AppTheme.amoled:
      return Translations.of(context)!.settings_theme_amoled;
    case AppTheme.dracula:
      return Translations.of(context)!.settings_theme_dracula;
    case AppTheme.nord:
      return Translations.of(context)!.settings_theme_nord;
    case AppTheme.sunset:
      return Translations.of(context)!.settings_theme_sunset;
  }
}

ThemeData getTheme(AppTheme userTheme) {
  switch (userTheme) {
    case AppTheme.light:
      return getDefault();
    case AppTheme.dark:
      return getDefault(brightness: Brightness.dark);
    case AppTheme.amoled:
      return getAmoled();
    case AppTheme.dracula:
      return getDracula();
    case AppTheme.nord:
      return getNord();
    case AppTheme.sunset:
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
