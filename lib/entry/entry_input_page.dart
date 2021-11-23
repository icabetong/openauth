import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/database/notifier.dart';
import 'package:openauth/settings/notifier.dart';
import 'package:openauth/shared/custom/dropdown_field.dart';
import 'package:openauth/shared/custom/switch.dart';
import 'package:otp/otp.dart';
import 'package:provider/provider.dart';

class InputRoute extends StatefulWidget {
  const InputRoute({Key? key}) : super(key: key);

  @override
  _InputRouteState createState() => _InputRouteState();
}

class _InputRouteState extends State<InputRoute> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _issuerController = TextEditingController();
  final _secretController = TextEditingController();
  final _periodController = TextEditingController(text: "30");
  final _lengthController = TextEditingController(text: "6");

  Algorithm _algorithm = Algorithm.SHA1;
  OTPType _type = OTPType.totp;
  bool _advancedOpen = false;
  bool _isSecretObscured = false;
  bool _isGoogle = true;

  void _save(Function(Entry) save) {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final issuer = _issuerController.text;
      final secret = _secretController.text;
      final period = int.parse(_periodController.text);
      final length = int.parse(_lengthController.text);
      final entry = Entry(secret, issuer, name,
          period: period,
          length: length,
          type: _type,
          algorithm: _algorithm,
          isGoogle: _isGoogle);

      save(entry);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceNotifier>(builder: (_context, _notifier, _child) {
      // If the user changed unhides the secrets from the app settings menu,
      // revert the obscurity of the secrets in this interface.
      if (!_notifier.preferences.isSecretsHidden && _isSecretObscured) {
        setState(() => _isSecretObscured = false);
      }

      return Consumer<EntryNotifier>(builder: (context, notifier, child) {
        return Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(elevation: 0),
                        onPressed: () {
                          _save(notifier.put);
                        },
                        icon: const Icon(Icons.save_outlined),
                        label: Text(Translations.of(context)!.button_save)),
                  )
                ]),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    Row(
                      children: [
                        const Icon(Icons.fingerprint_outlined,
                            color: Colors.grey),
                        const SizedBox(width: 16),
                        Expanded(
                            child: DropdownInputField<OTPType>(
                                items: OTPType.values,
                                labels: [
                                  Translations.of(context)!.otp_type_totp,
                                  Translations.of(context)!.otp_type_hotp
                                ],
                                onChange: (type) {
                                  setState(() => _type = type);
                                })),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          icon: const Icon(Icons.edit_outlined),
                          labelText: Translations.of(context)!.field_name),
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Translations.of(context)!
                              .error_name_cant_be_empty;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          icon: const Icon(Icons.badge_outlined),
                          labelText: Translations.of(context)!.field_issuer),
                      controller: _issuerController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Translations.of(context)!
                              .error_issuer_cant_be_empty;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: _notifier.preferences.isSecretsHidden,
                      enableSuggestions: !_notifier.preferences.isSecretsHidden,
                      autocorrect: !_notifier.preferences.isSecretsHidden,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          icon: const Icon(Icons.vpn_key_outlined),
                          labelText: Translations.of(context)!.field_secret,
                          suffixIcon: _notifier.preferences.isSecretsHidden
                              ? IconButton(
                                  icon: Icon(_isSecretObscured
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                  onPressed: () {
                                    // Prevent changing the obscurity of secrets
                                    // if 'Hide Secrets' is turned off in Settings
                                    if (_notifier.preferences.isSecretsHidden) {
                                      setState(() => _isSecretObscured =
                                          !_isSecretObscured);
                                    }
                                  },
                                )
                              : null),
                      controller: _secretController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Translations.of(context)!
                              .error_secret_cant_be_empty;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setState(() => _advancedOpen = !_advancedOpen);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(_advancedOpen
                                ? Translations.of(context)!.button_hide_advanced
                                : Translations.of(context)!
                                    .button_show_advanced),
                          ),
                          Icon(_advancedOpen
                              ? Icons.arrow_upward_outlined
                              : Icons.arrow_downward_outlined)
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedOpacity(
                        opacity: _advancedOpen ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Visibility(
                          visible: _advancedOpen,
                          child: Column(children: [
                            TextField(
                                controller: _periodController,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    icon: const Icon(Icons.lock_clock_outlined),
                                    labelText:
                                        Translations.of(context)!.field_period,
                                    suffixText: Translations.of(context)!
                                        .concat_seconds)),
                            const SizedBox(height: 16),
                            TextField(
                                controller: _lengthController,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    icon: const Icon(Icons.password_outlined),
                                    labelText:
                                        Translations.of(context)!.field_length,
                                    suffixText: Translations.of(context)!
                                        .concat_digits)),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.code, color: Colors.grey),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DropdownInputField<Algorithm>(
                                    items: Algorithm.values,
                                    labels: [
                                      Translations.of(context)!
                                          .algorithm_type_sha1,
                                      Translations.of(context)!
                                          .algorithm_type_sha256,
                                      Translations.of(context)!
                                          .algorithm_type_sha512
                                    ],
                                    onChange: (algorithm) {
                                      setState(() => _algorithm = algorithm);
                                    },
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.account_circle_outlined),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: SwitchField(
                                    labelText: Translations.of(context)!
                                        .field_is_google,
                                    checked: _isGoogle,
                                    onChange: (s) {
                                      setState(() => _isGoogle = s);
                                    },
                                  ),
                                ),
                              ],
                            )
                          ]),
                        )),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
            ));
      });
    });
  }
}