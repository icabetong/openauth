import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:openauth/settings/notifier.dart';
import 'package:provider/provider.dart';

class FirstRunPage extends StatelessWidget {
  const FirstRunPage({Key? key}) : super(key: key);

  final _vaultSvgWidth = 940.67538;
  final _vaultSvgHeight = 433.96214;
  final _loginSvgWidth = 793;
  final _loginSvgHeight = 551.73152;

  PageDecoration get _decoration => const PageDecoration(
      bodyTextStyle: TextStyle(color: Colors.grey, fontSize: 16));

  List<PageViewModel> _getPages(BuildContext context) {
    return <PageViewModel>[
      PageViewModel(
          title: Translations.of(context)!.intro_screen_1,
          body: Translations.of(context)!.intro_screen_1_desc,
          image: Center(
            child: SvgPicture.asset(
              'assets/secure-login.svg',
              width: _loginSvgWidth / 3,
              height: _loginSvgHeight / 3,
            ),
          ),
          decoration: _decoration),
      PageViewModel(
          title: Translations.of(context)!.intro_screen_2,
          body: Translations.of(context)!.intro_screen_2_desc,
          image: Center(
            child: SvgPicture.asset(
              'assets/vault.svg',
              width: _vaultSvgWidth / 3,
              height: _vaultSvgHeight / 3,
            ),
          ),
          decoration: _decoration),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: _getPages(context),
      next: const Icon(Icons.navigate_next_outlined),
      showNextButton: true,
      onDone: () {
        Provider.of<PreferenceNotifier>(context, listen: false)
            .changeFirstRun(false);
      },
      done: Text(Translations.of(context)!.button_lets_start),
      dotsDecorator:
          DotsDecorator(activeColor: Theme.of(context).colorScheme.primary),
    );
  }
}
