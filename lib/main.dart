import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/about/about.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/entry/entry_input_page.dart';
import 'package:openauth/database/database.dart';
import 'package:openauth/database/notifier.dart';
import 'package:openauth/locales/locales.dart';
import 'package:openauth/scan/scan_route.dart';
import 'package:openauth/settings/notifier.dart';
import 'package:openauth/settings/settings.dart';
import 'package:openauth/shared/countdown.dart';
import 'package:openauth/theme/core.dart';
import 'package:otp/otp.dart';
import 'package:provider/provider.dart';

void main() async {
  await HiveDatabase.init();
  runApp(const OpenAuth());
}

class OpenAuth extends StatelessWidget {
  const OpenAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => PreferenceNotifier(),
        child: Consumer<PreferenceNotifier>(builder: (context, notifier, _) {
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent));
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          return MaterialApp(
            supportedLocales: AppLocales.all,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              Translations.delegate
            ],
            onGenerateTitle: (context) => Translations.of(context)!.app_name,
            theme: getTheme(notifier.preferences.theme),
            home: const MainPage(),
          );
        }));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    return ChangeNotifierProvider(
      create: (_) => EntryNotifier(),
      child: Consumer<EntryNotifier>(builder: (context, notifier, child) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(Translations.of(context)!.app_name),
                snap: true,
                floating: true,
              ),
              notifier.entries.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(Translations.of(context)!.empty_accounts,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Text(
                                Translations.of(context)!
                                    .empty_accounts_subtitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade500))
                          ],
                        ),
                      ))
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                      final entry = notifier.entries[index];
                      return EntryListTile(
                          entry: entry, onRemove: notifier.remove);
                    }, childCount: notifier.entries.length))
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
              child: Row(children: [
            const Spacer(),
            PopupMenuButton<Route>(
                onSelected: (route) => Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      switch (route) {
                        case Route.settings:
                          return const SettingsRoute();
                        case Route.about:
                          return const AboutRoute();
                      }
                    })),
                itemBuilder: (context) => <PopupMenuEntry<Route>>[
                      PopupMenuItem(
                          child: Text(
                              Translations.of(context)!.navigation_settings),
                          value: Route.settings),
                      PopupMenuItem(
                          child:
                              Text(Translations.of(context)!.navigation_about),
                          value: Route.about)
                    ])
          ])),
        );
      }),
    );
  }
}

class EntryListTile extends StatefulWidget {
  const EntryListTile({Key? key, required this.entry, required this.onRemove})
      : super(key: key);
  final Entry entry;
  final Function(Entry) onRemove;

  @override
  State<EntryListTile> createState() => _EntryListTileState();
}

class _EntryListTileState extends State<EntryListTile> {
  CountDown? countdown;
  String? code;
  int time = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    final seconds = DateTime.now().second;
    if (seconds == 0) {
      countdown = CountDown(const Duration(seconds: 30));
      _countdown();
    } else if (seconds > 1 && seconds <= 30) {
      countdown = CountDown(Duration(seconds: seconds));
      _countdown();
    } else if (seconds >= 31 && seconds <= 60) {
      countdown = CountDown(Duration(seconds: 30 - (seconds - 30)));
      _countdown();
    }
  }

  void _countdown() {
    final sub = countdown?.stream?.listen(null);
    sub?.onDone(() {
      _start();
    });

    sub?.onData((data) {
      setState(() {
        time = data.inSeconds;
        if (time == 0 || code == null) {
          _generate();
        }
      });
    });
  }

  void _generate() {
    code = OTP.generateTOTPCodeString(
        widget.entry.secret, DateTime.now().millisecondsSinceEpoch,
        length: widget.entry.length,
        interval: widget.entry.period,
        algorithm: widget.entry.algorithm,
        isGoogle: true);
  }

  @override
  Widget build(BuildContext context) {
    double progress = time / 30;
    return ListTile(
        leading: CircularProgressIndicator(value: progress),
        title: Text(code ?? Translations.of(context)!.error_code_not_found),
        subtitle: Text(widget.entry.name + " - " + widget.entry.issuer),
        trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz_outlined),
            onSelected: (value) {
              widget.onRemove(widget.entry);
            },
            itemBuilder: (context) => <PopupMenuEntry<String>>[
                  PopupMenuItem(
                      child: Text(Translations.of(context)!.button_remove),
                      value: "delete")
                ]));
  }
}

enum Action { input, scan }
enum Route { settings, about }
