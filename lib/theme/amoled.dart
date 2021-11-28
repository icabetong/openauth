import 'package:flutter/material.dart';
import 'package:openauth/theme/core.dart';

ThemeData getAmoled() {
  const primary = Color(0xff3182CE);
  const onPrimary = Color(0xffffffff);
  const background = Color(0xff080808);
  const surface = Color(0xff1c1c1c);
  final popup = Color.lerp(surface, Colors.white, 0.05);

  return build(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: onPrimary,
    background: background,
    surface: surface,
    popup: popup,
  );
}
