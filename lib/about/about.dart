import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutRoute extends StatefulWidget {
  const AboutRoute({Key? key}) : super(key: key);

  @override
  _AboutRouteState createState() => _AboutRouteState();
}

class _AboutRouteState extends State<AboutRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Translations.of(context)!.menu_about)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
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
            Expanded(
              child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.code),
                            title:
                                Text(Translations.of(context)!.about_version),
                            subtitle: Text(snapshot.data!.version),
                          ),
                          ListTile(
                              leading: const Icon(Icons.description_outlined),
                              title: Text(
                                  Translations.of(context)!.about_changelog)),
                          ListTile(
                              leading: const Icon(Icons.source_outlined),
                              title: Text(
                                  Translations.of(context)!.about_source_code)),
                          ListTile(
                              leading: const Icon(Icons.rule_folder_outlined),
                              title: Text(
                                  Translations.of(context)!.about_license)),
                          ListTile(
                              leading: const Icon(Icons.build_outlined),
                              title: Text(
                                  Translations.of(context)!.about_third_party))
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
      ),
    );
  }
}
