import 'package:flutter/material.dart';
import 'package:openauth/theme/core.dart';

ThemeData getSunset() {
  const primary = Color(0xfffa8830);
  const onPrimary = Color(0xff000000);
  const surface = Color(0xff082336);
  final background = Color.lerp(surface, Colors.black, 0.5);

  return build(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: onPrimary,
    background: background,
    surface: surface,
  );
}
