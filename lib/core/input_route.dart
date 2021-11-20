import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/core/entry.dart';
import 'package:openauth/database/notifier.dart';
import 'package:provider/provider.dart';

class InputRoute extends StatefulWidget {
  const InputRoute({Key? key}) : super(key: key);

  @override
  _InputRouteState createState() => _InputRouteState();
}

class _InputRouteState extends State<InputRoute> {
  final nameController = TextEditingController();
  final issuerController = TextEditingController();
  final secretController = TextEditingController();

  void _save(Function(Entry) save) {
    final name = nameController.text;
    final issuer = issuerController.text;
    final secret = secretController.text;
    final entry = Entry(secret, issuer, name);

    save(entry);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EntryNotifier>(builder: (context, notifier, child) {
      return Scaffold(
          appBar: AppBar(elevation: 0, actions: [
            Container(
              margin: const EdgeInsets.all(8),
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(elevation: 0),
                  onPressed: () {
                    _save(notifier.put);
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: Text(Translations.of(context)!.button_save)),
            )
          ]),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              TextField(
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    icon: const Icon(Icons.edit_outlined),
                    labelText: Translations.of(context)!.field_name),
                controller: nameController,
              ),
              const SizedBox(height: 16),
              TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      icon: const Icon(Icons.badge_outlined),
                      labelText: Translations.of(context)!.field_issuer),
                  controller: issuerController),
              const SizedBox(height: 16),
              TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      icon: const Icon(Icons.vpn_key_outlined),
                      labelText: Translations.of(context)!.field_secret),
                  controller: secretController),
            ]),
          ));
    });
  }
}
