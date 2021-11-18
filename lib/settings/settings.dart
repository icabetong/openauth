import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/theme/provider.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          Consumer<ThemeProvider>(builder: (context, notifier, child) {
        return FloatingActionButton(onPressed: () {
          debugPrint(notifier.userTheme.toString());
          notifier.change();
        });
      }),
      appBar:
          AppBar(title: Text(Translations.of(context)!.navigation_settings)),
      body: SettingsList(
        backgroundColor: Theme.of(context).colorScheme.surface,
        sections: [
          SettingsSection(tiles: [
            SettingsTile(
              leading: const Icon(Icons.palette_outlined),
              title: Translations.of(context)!.settings_theme,
              onPressed: (context) {},
            )
          ])
        ],
      ),
    );
  }
}
