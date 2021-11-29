import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header(
      {Key? key, this.icon, required this.title, required this.subtitle})
      : super(key: key);

  final IconData? icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32),
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
