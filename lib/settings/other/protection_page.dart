import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/settings/provider.dart';
import 'package:openauth/shared/custom/header.dart';

class ProtectionPage extends StatefulWidget {
  const ProtectionPage({Key? key}) : super(key: key);

  @override
  _ProtectionPageState createState() => _ProtectionPageState();
}

class _ProtectionPageState extends State<ProtectionPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _onSavePassphrase() async {
    if (_formKey.currentState!.validate()) {
      await PassphraseHandler.setPassphrase(_passwordController.text);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Header(
                          icon: Icons.admin_panel_settings_outlined,
                          title: Translations.of(context)!
                              .title_setup_app_protection,
                          subtitle: Translations.of(context)!
                              .title_setup_app_protection_subtitle,
                        ),
                        TextFormField(
                          obscureText: !_isPasswordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: _passwordController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() =>
                                      _isPasswordVisible = !_isPasswordVisible);
                                },
                                icon: Icon(_isPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                              ),
                              border: const OutlineInputBorder(),
                              labelText:
                                  Translations.of(context)!.field_password),
                          validator: (value) {
                            if (value != null && value.trim().isEmpty) {
                              return Translations.of(context)!
                                  .error_passphrase_empty;
                            } else if (value !=
                                _confirmPasswordController.text) {
                              return Translations.of(context)!
                                  .error_passphrase_not_matched;
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          obscureText: !_isConfirmPasswordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() => _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible);
                                },
                                icon: Icon(_isConfirmPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                              ),
                              border: const OutlineInputBorder(),
                              labelText: Translations.of(context)!
                                  .field_confirm_password),
                          validator: (value) {
                            if (value != null && value.trim().isEmpty) {
                              return Translations.of(context)!
                                  .error_confirm_passphrase_empty;
                            } else if (value != _passwordController.text) {
                              return Translations.of(context)!
                                  .error_passphrase_not_matched;
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                            onPressed: _onSavePassphrase,
                            child:
                                Text(Translations.of(context)!.button_continue))
                      ],
                    ),
                  ),
                )),
          )),
    );
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context, false);
    return Future.value(true);
  }
}
