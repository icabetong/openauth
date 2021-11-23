import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/auth/unlock_notifier.dart';
import 'package:openauth/settings/provider.dart';
import 'package:provider/provider.dart';

class UnlockPage extends StatefulWidget {
  const UnlockPage({Key? key}) : super(key: key);

  @override
  _UnlockPageState createState() => _UnlockPageState();
}

class _UnlockPageState extends State<UnlockPage> {
  final _passphraseController = TextEditingController();
  String? _error;
  bool _isPasswordShown = false;

  void _onAuthenticate(context) async {
    final input = _passphraseController.text;
    if (input.trim().isEmpty) {
      setState(() => _error = Translations.of(context)!.error_passphrase_empty);
      return;
    }

    final passphrase = await PassphraseHandler.getPassphrase();
    final provided = base64Encode(input.codeUnits);

    if (passphrase != provided) {
      setState(
          () => _error = Translations.of(context)!.error_passphrase_invalid);
      return;
    }
    Provider.of<UnlockNotifier>(context, listen: false).change(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.admin_panel_settings_outlined, size: 32),
                  Text(Translations.of(context)!.title_unlock_app,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(Translations.of(context)!.title_unlock_app_subtitle,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  TextFormField(
                    obscureText: !_isPasswordShown,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _passphraseController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: Translations.of(context)!.field_password,
                        errorText: _error,
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                  () => _isPasswordShown = !_isPasswordShown);
                            },
                            icon: Icon(_isPasswordShown
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined))),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: Text(Translations.of(context)!.button_unlock),
                    onPressed: () {
                      _onAuthenticate(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
