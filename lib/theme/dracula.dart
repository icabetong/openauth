import 'package:flutter/material.dart';
import 'package:openauth/theme/core.dart';

ThemeData getDracula() {
  const primary = Color(0xffbd93f9);
  const onPrimary = Color(0xff000000);
  const surface = Color(0xff44475a);
  const background = Color(0xff282a36);

  return build(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: onPrimary,
    background: background,
    surface: surface,
  );
}
