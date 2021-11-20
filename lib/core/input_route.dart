import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/database/notifier.dart';
import 'package:provider/provider.dart';

class InputRoute extends StatefulWidget {
  const InputRoute({Key? key}) : super(key: key);

  @override
  _InputRouteState createState() => _InputRouteState();
}

class _InputRouteState extends State<InputRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () {},
                icon: const Icon(Icons.save_outlined),
                label: Text(Translations.of(context)!.button_save)),
          )
        ]),
        body: Consumer<EntryNotifier>(builder: (context, notifier, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              TextField(
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    icon: const Icon(Icons.edit_outlined),
                    labelText: Translations.of(context)!.field_name),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    icon: const Icon(Icons.badge_outlined),
                    labelText: Translations.of(context)!.field_issuer),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    icon: const Icon(Icons.vpn_key_outlined),
                    labelText: Translations.of(context)!.field_secret),
              ),
            ]),
          );
        }));
  }
}
