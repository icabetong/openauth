import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/settings/notifier.dart';
import 'package:openauth/settings/provider.dart';
import 'package:openauth/theme/core.dart';
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
        appBar:
            AppBar(title: Text(Translations.of(context)!.navigation_settings)),
        body: Consumer<PreferenceNotifier>(builder: (context, notifier, child) {
          return SettingsList(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            sections: [
              SettingsSection(tiles: [
                SettingsTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: Translations.of(context)!.settings_theme,
                  subtitle: getThemeName(context, notifier.preferences.theme),
                  onPressed: (context) async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ThemeSelectionRoute(
                                theme: notifier.preferences.theme)));
                    if (result != null) {
                      notifier.changeTheme(result);
                    }
                  },
                )
              ])
            ],
          );
        }));
  }
}

class ThemeSelectionRoute extends StatefulWidget {
  const ThemeSelectionRoute({Key? key, required this.theme}) : super(key: key);

  final UserTheme theme;

  @override
  _ThemeSelectionRouteState createState() => _ThemeSelectionRouteState();
}

class _ThemeSelectionRouteState extends State<ThemeSelectionRoute> {
  final themes = UserTheme.values;

  Widget getLeadingIcon(theme) {
    return theme == widget.theme
        ? const Icon(Icons.check_rounded)
        : const Icon(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Translations.of(context)!.settings_theme)),
      body: ListView.builder(
          itemBuilder: (context, index) => ListTile(
              title: Text(getThemeName(context, themes[index])),
              leading: getLeadingIcon(themes[index]),
              onTap: () {
                Navigator.pop(context, themes[index]);
              }),
          itemCount: themes.length),
    );
  }
}