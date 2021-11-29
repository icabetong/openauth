import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/settings/other/export_page.dart';
import 'package:openauth/settings/other/protection_page.dart';
import 'package:openauth/settings/notifier.dart';
import 'package:openauth/shared/custom/preference.dart';
import 'package:openauth/theme/core.dart';
import 'package:provider/provider.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PreferenceNotifier>(
        builder: (context, notifier, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(Translations.of(context)!.menu_settings),
                pinned: true,
              ),
              PreferenceList(
                items: [
                  PreferenceGroup(
                    header: Translations.of(context)!.settings_group_display,
                    tiles: [
                      PreferenceTile(
                        leading: const Icon(Icons.palette_outlined),
                        title: Translations.of(context)!.settings_theme,
                        subtitle:
                            getThemeName(context, notifier.preferences.theme),
                        subtitleMaxLines: 1,
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
                    ],
                  ),
                  PreferenceGroup(
                    header: Translations.of(context)!.settings_group_behavior,
                    tiles: [
                      PreferenceTile.switchTile(
                          leading: const Icon(Icons.copy_outlined),
                          title: Translations.of(context)!.settings_tap_to_copy,
                          subtitle: Translations.of(context)!
                              .settings_tap_to_copy_subtitle,
                          onToggle: (checked) {
                            notifier.changeTapToCopy(checked);
                          },
                          checked: notifier.preferences.tapToCopy)
                    ],
                  ),
                  PreferenceGroup(
                    header: Translations.of(context)!.settings_group_security,
                    tiles: [
                      PreferenceTile.switchTile(
                          leading: const Icon(Icons.touch_app_outlined),
                          title:
                              Translations.of(context)!.settings_tap_to_reveal,
                          subtitle: Translations.of(context)!
                              .settings_tap_to_reveal_subtitle,
                          onToggle: (checked) {
                            notifier.changeHideTokens(checked);
                          },
                          checked: notifier.preferences.hideTokens),
                      PreferenceTile.switchTile(
                          leading: const Icon(Icons.visibility_off_outlined),
                          title:
                              Translations.of(context)!.settings_hide_secrets,
                          subtitle: Translations.of(context)!
                              .settings_hide_secrets_subtitle,
                          onToggle: (status) {
                            setState(() {
                              notifier.changeSecretsHidden(status);
                            });
                          },
                          checked: notifier.preferences.isSecretsHidden),
                      PreferenceTile.switchTile(
                        leading:
                            const Icon(Icons.admin_panel_settings_outlined),
                        title: Translations.of(context)!
                            .settings_access_protection,
                        subtitle: Translations.of(context)!
                            .settings_access_protection_subtitle,
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
                        checked: notifier.preferences.isAppProtected,
                        subtitleMaxLines: 1,
                      )
                    ],
                  ),
                  PreferenceGroup(
                    header: Translations.of(context)!.settings_group_backup,
                    tiles: [
                      PreferenceTile(
                        leading: const Icon(Icons.file_download_outlined),
                        title: Translations.of(context)!.settings_import,
                        subtitle:
                            Translations.of(context)!.settings_import_subtitle,
                        subtitleMaxLines: 1,
                      ),
                      PreferenceTile(
                        leading: const Icon(Icons.file_upload_outlined),
                        title: Translations.of(context)!.settings_export,
                        subtitle:
                            Translations.of(context)!.settings_export_subtitle,
                        subtitleMaxLines: 1,
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondAnimation) =>
                                      const ExportPage(),
                              transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) =>
                                  SharedAxisTransition(
                                      child: child,
                                      animation: animation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType:
                                          SharedAxisTransitionType.horizontal),
                            ),
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class ThemeSelectionRoute extends StatefulWidget {
  const ThemeSelectionRoute({Key? key, required this.theme}) : super(key: key);

  final AppTheme theme;

  @override
  _ThemeSelectionRouteState createState() => _ThemeSelectionRouteState();
}

class _ThemeSelectionRouteState extends State<ThemeSelectionRoute> {
  final themes = AppTheme.values;

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
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(getThemeName(context, themes[index])),
              leading: getLeadingIcon(themes[index]),
              onTap: () {
                Navigator.pop(context, themes[index]);
              },
            );
          },
          itemCount: themes.length),
    );
  }
}
