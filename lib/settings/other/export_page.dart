import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/database/repository.dart';
import 'package:openauth/shared/constants.dart';
import 'package:openauth/shared/custom/header.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({Key? key}) : super(key: key);

  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  final _fileName = "export.txt";
  String? _directory;
  bool _writing = false;

  void _onSave() async {
    setState(() => _writing = true);
    final repository = EntryRepository();
    final entries = repository.fetch();

    final directory = '$_directory/$_fileName';
    final file = File(directory);
    await file.create();
    await file.writeAsString(jsonEncode(entries));
    setState(() => _writing = false);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(Translations.of(context)!.feedback_export_success),
      ),
    );
  }

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
              icon: Icons.upload_file_outlined,
              title: Translations.of(context)!.title_export,
              subtitle: Translations.of(context)!.title_export_subtitle,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _directory ?? Translations.of(context)!.no_destination_set,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                    onPressed: () async {
                      final directory =
                          await FilePicker.platform.getDirectoryPath();
                      setState(() {
                        _directory = directory;
                      });
                    },
                    child: Text(Translations.of(context)!.button_browse))
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _writing ? null : _onSave,
              child: Text(Translations.of(context)!.button_export),
            )
          ],
        ),
      ),
    );
  }
}
