import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/shared/constants.dart';
import 'package:openauth/shared/custom/header.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({Key? key}) : super(key: key);

  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: pagePadding,
        child: Column(
          children: [
            Header(
              icon: Icons.download_outlined,
              title: Translations.of(context)!.title_import,
              subtitle: Translations.of(context)!.title_import_subtitle,
            )
          ],
        ),
      ),
    );
  }
}
