import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter/material.dart';
import 'package:openauth/theme/amoled.dart';
import 'package:openauth/theme/default.dart';
import 'package:openauth/theme/dracula.dart';
import 'package:openauth/theme/nord.dart';
import 'package:openauth/theme/sunset.dart';

enum AppTheme { light, dark, amoled, dracula, nord, sunset }

extension AppThemeExtension on AppTheme {
  static const _light = "light";
  static const _dark = "dark";
  static const _amoled = "amoled";
  static const _dracula = "dracula";
  static const _nord = "nord";
  static const _sunset = "sunset";

  String get value {
    switch (this) {
      case AppTheme.light:
        return _light;
      case AppTheme.dark:
        return _dark;
      case AppTheme.amoled:
        return _amoled;
      case AppTheme.dracula:
        return _dracula;
      case AppTheme.nord:
        return _nord;
      case AppTheme.sunset:
        return _sunset;
    }
  }

  static AppTheme parse(String theme) {
    switch (theme) {
      case _light:
        return AppTheme.light;
      case _dark:
        return AppTheme.dark;
      case _amoled:
        return AppTheme.amoled;
      case _dracula:
        return AppTheme.dracula;
      case _nord:
        return AppTheme.nord;
      case _sunset:
        return AppTheme.sunset;
      default:
        throw Exception("Invalid theme value");
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

ThemeData build(
    {Brightness? brightness,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? background,
    Color? surface,
    Color? onSurface,
    Color? error,
    Color? onError,
    Color? popup}) {
  final base = getBase(brightness: brightness ?? Brightness.light);
  primary ??= base.colorScheme.primary;
  onPrimary ??= base.colorScheme.onPrimary;
  surface ??= base.colorScheme.surface;
  onSurface ??= base.colorScheme.onSurface;
  error ??= base.colorScheme.error;
  onError ??= base.colorScheme.onError;
  background ??= base.scaffoldBackgroundColor;
  secondary ??= primary;
  onSecondary ??= onPrimary;
  popup ??= surface;

  return base.copyWith(
    scaffoldBackgroundColor: background,
    bottomAppBarColor: surface,
    colorScheme: base.colorScheme.copyWith(
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      surface: surface,
      onSurface: onSurface,
      error: error,
      onError: onError,
    ),
    popupMenuTheme: base.popupMenuTheme.copyWith(color: surface),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(backgroundColor: surface),
    cardTheme: base.cardTheme.copyWith(color: surface),
  );
}
