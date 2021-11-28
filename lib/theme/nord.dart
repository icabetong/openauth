import 'package:flutter/material.dart';
import 'package:openauth/theme/core.dart';

ThemeData getNord() {
  const primary = Color(0xff8FBCBB);
  const onPrimary = Color(0xff000000);
  const background = Color(0xff2E3440);
  const surface = Color(0xff3B4252);
  const onSurface = Color(0xffffffff);

  return build(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: onPrimary,
    background: background,
    surface: surface,
    onSurface: onSurface,
  );
}
