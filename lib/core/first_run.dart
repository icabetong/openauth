import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:openauth/settings/notifier.dart';
import 'package:provider/provider.dart';

class FirstRunPage extends StatelessWidget {
  const FirstRunPage({Key? key}) : super(key: key);

  final width = 940.67538;
  final height = 433.96214;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Text(Translations.of(context)!.app_name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5),
                const SizedBox(height: 8),
                Text(Translations.of(context)!.app_desc,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
            const SizedBox(height: 64),
            SvgPicture.asset(
              'assets/vault.svg',
              width: width / 4,
              height: height / 4,
              fit: BoxFit.scaleDown,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
                onPressed: () {
                  Provider.of<PreferenceNotifier>(context, listen: false)
                      .changeFirstRun(false);
                },
                child: Text(Translations.of(context)!.button_lets_start))
          ],
        ),
      ),
    );
  }
}
