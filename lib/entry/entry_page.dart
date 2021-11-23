import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/about/about.dart';
import 'package:openauth/database/notifier.dart';
import 'package:openauth/entry/entry_input_page.dart';
import 'package:openauth/entry/entry_list.dart';
import 'package:openauth/scan/scan_route.dart';
import 'package:openauth/settings/settings.dart';
import 'package:provider/provider.dart';

enum Action { input, scan }
enum Route { settings, about }

class EntryPage extends StatefulWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  Future<Action?> _invoke() async {
    return await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(Translations.of(context)!.title_add_account,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 18)),
                const SizedBox(height: 32),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context, Action.scan);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                const Icon(Icons.scanner_outlined),
                                Text(Translations.of(context)!.button_scan)
                              ],
                            ),
                          )),
                      OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context, Action.input);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                const Icon(Icons.edit_outlined),
                                Text(Translations.of(context)!.button_input)
                              ],
                            ),
                          ))
                    ]),
                const SizedBox(height: 16)
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EntryNotifier>(builder: (context, notifier, child) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(Translations.of(context)!.app_name),
              snap: true,
              floating: true,
            ),
            notifier.entries.isEmpty
                ? const EmptyEntry()
                : EntryList(
                    entries: notifier.entries,
                  )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final Action? result = await _invoke();
              if (result != null) {
                switch (result) {
                  case Action.input:
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ChangeNotifierProvider<EntryNotifier>.value(
                          value: notifier, child: const InputRoute());
                    }));
                    break;
                  case Action.scan:
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ChangeNotifierProvider<EntryNotifier>.value(
                          value: notifier, child: const ScanRoute());
                    }));
                    break;
                }
              }
            },
            icon: const Icon(Icons.add),
            label: Text(Translations.of(context)!.button_add)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            child: Row(children: [
          const Spacer(),
          PopupMenuButton<Route>(
              onSelected: (route) =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    switch (route) {
                      case Route.settings:
                        return const SettingsRoute();
                      case Route.about:
                        return const AboutRoute();
                    }
                  })),
              itemBuilder: (context) => <PopupMenuEntry<Route>>[
                    PopupMenuItem(
                        child:
                            Text(Translations.of(context)!.navigation_settings),
                        value: Route.settings),
                    PopupMenuItem(
                        child: Text(Translations.of(context)!.navigation_about),
                        value: Route.about)
                  ])
        ])),
      );
    });
  }
}
