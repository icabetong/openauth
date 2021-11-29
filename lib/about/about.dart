import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class AboutRoute extends StatefulWidget {
  const AboutRoute({Key? key}) : super(key: key);

  @override
  _AboutRouteState createState() => _AboutRouteState();
}

class _AboutRouteState extends State<AboutRoute> {
  static const _license = "GPL-3.0 License";
  static const _repository = "https://github.com/icabetong/openauth";
  static const _changelog = '$_repository/blob/master/CHANGELOG.md';
  static const _licenseUrl = '$_repository/blob/master/LICENSE';

  @override
  Widget build(BuildContext context) {
    void _launchUrlFallback(String url) async {
      if (!await UrlLauncher.launch(url)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.of(context)!.error_generic),
          ),
        );
      }
    }

    void _launchUrl(BuildContext context, String url) async {
      if (Platform.isAndroid || Platform.isIOS) {
        try {
          await launch(
            url,
            customTabsOption: CustomTabsOption(
              showPageTitle: true,
              enableDefaultShare: true,
              enableUrlBarHiding: true,
              animation: CustomTabsSystemAnimation.slideIn(),
            ),
          );
        } catch (e) {
          _launchUrlFallback(url);
        }
      } else {
        _launchUrlFallback(url);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(Translations.of(context)!.menu_about)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(Translations.of(context)!.app_name,
                        style: Theme.of(context).textTheme.headline5),
                    const SizedBox(height: 8),
                    Text(Translations.of(context)!.app_desc,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.code),
                          title: Text(Translations.of(context)!.about_version),
                          subtitle: Text(snapshot.data!.version),
                        ),
                        ListTile(
                          leading: const Icon(Icons.restore_page_outlined),
                          title:
                              Text(Translations.of(context)!.about_changelog),
                          subtitle: Text(Translations.of(context)!
                              .about_changelog_subtitle),
                          onTap: () {
                            _launchUrl(context, _changelog);
                          },
                        ),
                        ListTile(
                          leading: const Icon(SimpleIcons.github),
                          title: Text(Translations.of(context)!.about_github),
                          subtitle: Text(
                              Translations.of(context)!.about_github_subtitle),
                          onTap: () {
                            _launchUrl(context, _repository);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.description_outlined),
                          title: Text(Translations.of(context)!.about_license),
                          subtitle: const Text(_license),
                          onTap: () {
                            _launchUrl(context, _licenseUrl);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.people_alt_outlined),
                          title: Text(
                              Translations.of(context)!.about_acknowledgements),
                          subtitle: Text(Translations.of(context)!
                              .about_acknowledgements_subtitle),
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Container();
                  }

                  return const Center(child: CircularProgressIndicator());
                }),
          ),
        ],
      ),
    );
  }
}
