import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/database/notifier.dart';
import 'package:openauth/settings/notifier.dart';
import 'package:openauth/settings/provider.dart';
import 'package:openauth/shared/custom/dropdown_field.dart';
import 'package:openauth/shared/custom/switch.dart';
import 'package:otp/otp.dart';
import 'package:provider/provider.dart';

enum Operation { create, update }

class InputPage extends StatefulWidget {
  const InputPage({Key? key, this.entry}) : super(key: key);

  final Entry? entry;

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _issuerController;
  late TextEditingController _secretController;
  late TextEditingController _periodController;
  late TextEditingController _lengthController;
  late TextEditingController _counterController;

  @override
  void initState() {
    super.initState();

    PreferenceHandler.isSecretsHidden
        .then((secrets) => setState(() => _isSecretObscured = secrets));

    final isUpdate = widget.entry != null;
    _nameController = TextEditingController(text: widget.entry?.name);
    _issuerController = TextEditingController(text: widget.entry?.issuer);
    _secretController = TextEditingController(text: widget.entry?.secret);
    _periodController = TextEditingController(
        text: isUpdate ? '${widget.entry!.period}' : '${Entry.defaultPeriod}');
    _lengthController = TextEditingController(
        text: isUpdate ? '${widget.entry!.length}' : '${Entry.defaultLength}');
    _counterController = TextEditingController(
        text:
            isUpdate ? '${widget.entry!.counter}' : '${Entry.defaultCounter}');
  }

  Algorithm _algorithm = Algorithm.SHA1;
  OTPType _type = OTPType.totp;
  bool _advancedOpen = false;
  bool _isSecretObscured = false;
  bool _isGoogle = true;

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final issuer = _issuerController.text;
      final secret = _secretController.text;
      final period = int.parse(_periodController.text);
      final length = int.parse(_lengthController.text);

      final entry = Entry(secret, issuer, name,
          // Passing an empty string in the optional parameter generates
          // a new id.
          entryId: widget.entry?.entryId ?? "",
          period: period,
          length: length,
          type: _type,
          algorithm: _algorithm,
          isGoogle: _isGoogle);

      final result = Provider.of<EntryNotifier>(context, listen: false)
          .check(entry.entryId, secret, _type);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(Translations.of(context)!.feedback_entry_already_exists),
          ),
        );
        return;
      }

      await Provider.of<EntryNotifier>(context, listen: false).put(entry);
      Navigator.pop(
          context, widget.entry != null ? Operation.update : Operation.create);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceNotifier>(builder: (_context, _notifier, _child) {
      return Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(elevation: 0),
                    onPressed: () {
                      _onSave();
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: Text(Translations.of(context)!.button_save)),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      icon: const Icon(Icons.edit_outlined),
                      labelText: Translations.of(context)!.field_name,
                    ),
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
                      labelText: Translations.of(context)!.field_issuer,
                    ),
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
                    obscureText: _isSecretObscured,
                    enableSuggestions: !_notifier.preferences.isSecretsHidden,
                    autocorrect: !_notifier.preferences.isSecretsHidden,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        icon: const Icon(Icons.fingerprint_outlined),
                        labelText: Translations.of(context)!.field_secret,
                        suffixIcon: _notifier.preferences.isSecretsHidden
                            ? IconButton(
                                icon: Icon(!_isSecretObscured
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                                onPressed: () {
                                  // Prevent changing the obscurity of secrets
                                  // if 'Hide Secrets' is turned off in Settings
                                  if (_notifier.preferences.isSecretsHidden) {
                                    setState(() =>
                                        _isSecretObscured = !_isSecretObscured);
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
                              : Translations.of(context)!.button_show_advanced),
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
                          Row(
                            children: [
                              const Icon(Icons.vpn_key_outlined,
                                  color: Colors.grey),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: DropdownInputField<OTPType>(
                                      selected: _type,
                                      items: OTPType.values,
                                      labels: [
                                        Translations.of(context)!.otp_type_totp,
                                        Translations.of(context)!.otp_type_hotp,
                                        Translations.of(context)!.otp_type_steam
                                      ],
                                      onChange: (type) {
                                        setState(() => _type = type);
                                      })),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                              enabled: _type != OTPType.steam,
                              controller: _periodController,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  icon: const Icon(Icons.lock_clock_outlined),
                                  labelText:
                                      Translations.of(context)!.field_period,
                                  suffixText: Translations.of(context)!
                                      .concat_seconds)),
                          const SizedBox(height: 16),
                          _type == OTPType.hotp
                              ? TextField(
                                  controller: _counterController,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      icon: const Icon(Icons.plus_one),
                                      labelText: Translations.of(context)!
                                          .field_counter),
                                )
                              : TextField(
                                  enabled: _type != OTPType.steam,
                                  controller: _lengthController,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      icon: const Icon(Icons.password_outlined),
                                      labelText: Translations.of(context)!
                                          .field_length,
                                      suffixText: Translations.of(context)!
                                          .concat_digits),
                                ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.code, color: Colors.grey),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownInputField<Algorithm>(
                                  enabled: _type != OTPType.steam,
                                  selected: _algorithm,
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
                              const Icon(Icons.account_circle_outlined,
                                  color: Colors.grey),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SwitchField(
                                  enabled: _type != OTPType.steam,
                                  labelText:
                                      Translations.of(context)!.field_is_google,
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
          )
        ]),
      );
    });
  }
}
