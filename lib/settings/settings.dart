import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/settings/other/protection_page.dart';
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
  Color get _themeColor => Theme.of(context).colorScheme.primary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Translations.of(context)!.menu_settings)),
        body: Consumer<PreferenceNotifier>(builder: (context, notifier, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SettingsList(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              sections: [
                SettingsSection(
                    title: Translations.of(context)!.settings_group_display,
                    titleTextStyle: _headerTextStyle,
                    tiles: [
                      SettingsTile(
                        leading: const Icon(Icons.palette_outlined),
                        title: Translations.of(context)!.settings_theme,
                        subtitle:
                            getThemeName(context, notifier.preferences.theme),
                        titleTextStyle: _titleTextStyle,
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
                      ),
                    ]),
                SettingsSection(
                    title: Translations.of(context)!.settings_group_security,
                    titleTextStyle: _headerTextStyle,
                    tiles: [
                      SettingsTile.switchTile(
                          leading: const Icon(Icons.visibility_off_outlined),
                          switchActiveColor: _themeColor,
                          title:
                              Translations.of(context)!.settings_hide_secrets,
                          subtitle: Translations.of(context)!
                              .settings_hide_secrets_subtitle,
                          subtitleMaxLines: 3,
                          titleTextStyle: _titleTextStyle,
                          onToggle: (status) {
                            setState(() {
                              notifier.changeSecretsHidden(status);
                            });
                          },
                          switchValue: notifier.preferences.isSecretsHidden),
                      SettingsTile.switchTile(
                          leading:
                              const Icon(Icons.admin_panel_settings_outlined),
                          switchActiveColor: _themeColor,
                          title: Translations.of(context)!
                              .settings_access_protection,
                          titleTextStyle: _titleTextStyle,
                          subtitle: Translations.of(context)!
                              .settings_access_protection_subtitle,
                          subtitleMaxLines: 3,
                          onToggle: (status) async {
                            bool isAppProtected = status;
                            if (status) {
                              final result = Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const ProtectionPage(),
                                      transitionsBuilder: (context, animation,
                                              secondaryAnimation, child) =>
                                          SharedAxisTransition(
                                              child: child,
                                              animation: animation,
                                              secondaryAnimation:
                                                  secondaryAnimation,
                                              transitionType:
                                                  SharedAxisTransitionType
                                                      .horizontal)));
                              isAppProtected = await result;
                            }
                            setState(() {
                              notifier.changeProtection(isAppProtected);
                            });
                          },
                          switchValue: notifier.preferences.isAppProtected)
                    ])
              ],
            ),
          );
        }));
  }

  TextStyle get _titleTextStyle => const TextStyle(fontWeight: FontWeight.w500);
  TextStyle get _headerTextStyle =>
      TextStyle(color: _themeColor, fontWeight: FontWeight.w500);
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
