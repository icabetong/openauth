import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class ScanRoute extends StatefulWidget {
  const ScanRoute({Key? key}) : super(key: key);

  @override
  _ScanRouteState createState() => _ScanRouteState();
}

class _ScanRouteState extends State<ScanRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context)!.app_name),
      ),
    );
  }
}
