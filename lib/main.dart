import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/about/about.dart';
import 'package:openauth/locales/locales.dart';
import 'package:openauth/settings/settings.dart';
import 'package:openauth/theme/default.dart';
import 'package:openauth/theme/provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const OpenAuth());
}

class OpenAuth extends StatelessWidget {
  const OpenAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: Consumer<ThemeProvider>(builder: (context, notifier, child) {
          return MaterialApp(
            supportedLocales: AppLocales.all,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              Translations.delegate
            ],
            onGenerateTitle: (context) => Translations.of(context)!.app_name,
            theme: getDefault(notifier.userTheme),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(Translations.of(context)!.app_name),
            pinned: true,
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(title: Text(index.toString()))))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add_rounded),
          onPressed: () async {},
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
  }
}

enum Route { settings, about }
