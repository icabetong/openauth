import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class AboutRoute extends StatefulWidget {
  const AboutRoute({Key? key}) : super(key: key);

  @override
  _AboutRouteState createState() => _AboutRouteState();
}

class _AboutRouteState extends State<AboutRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context)!.navigation_about),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
