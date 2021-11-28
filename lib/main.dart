import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/auth/unlock_notifier.dart';
import 'package:openauth/auth/unlock_page.dart';
import 'package:openauth/core/first_run.dart';
import 'package:openauth/database/database.dart';
import 'package:openauth/database/notifier.dart';
import 'package:openauth/entry/entry_page.dart';
import 'package:openauth/locales/locales.dart';
import 'package:openauth/settings/notifier.dart';
import 'package:openauth/theme/core.dart';
import 'package:provider/provider.dart';

void main() async {
  await HiveDatabase.init();
  runApp(const OpenAuth());
}

class OpenAuth extends StatelessWidget {
  const OpenAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PreferenceNotifier()),
          ChangeNotifierProvider(create: (_) => UnlockNotifier()),
          ChangeNotifierProvider(create: (_) => EntryNotifier())
        ],
        child: Consumer<PreferenceNotifier>(
          builder: (context, notifier, _) {
            final _theme = getTheme(notifier.preferences.theme);

            SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.transparent,
                systemStatusBarContrastEnforced: false,
                statusBarColor: Colors.transparent));
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            return MaterialApp(
              supportedLocales: AppLocales.all,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                Translations.delegate
              ],
              home: notifier.preferences.isFirstRun
                  ? const FirstRunPage()
                  : const MainPage(),
              onGenerateTitle: (context) => Translations.of(context)!.app_name,
              theme: _theme,
            );
          },
        ));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UnlockNotifier>(
      builder: (context, notifier, _) {
        return notifier.requireAuthentication
            ? notifier.isAuthenticated
                ? const EntryPage()
                : const UnlockPage()
            : const EntryPage();
      },
    );
  }
}
