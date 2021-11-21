import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/database/notifier.dart';
import 'package:otp/otp.dart';
import 'package:provider/provider.dart';

class InputRoute extends StatefulWidget {
  const InputRoute({Key? key}) : super(key: key);

  @override
  _InputRouteState createState() => _InputRouteState();
}

class _InputRouteState extends State<InputRoute> {
  final _nameController = TextEditingController();
  final _issuerController = TextEditingController();
  final _secretController = TextEditingController();
  final _periodController = TextEditingController(text: "30");
  final _lengthController = TextEditingController(text: "6");

  Algorithm _algorithm = Algorithm.SHA1;
  OTPType _type = OTPType.totp;
  bool _advancedOpen = false;

  void _save(Function(Entry) save) {
    final name = _nameController.text;
    final issuer = _issuerController.text;
    final secret = _secretController.text;
    final period = int.parse(_periodController.text);
    final length = int.parse(_lengthController.text);
    final entry = Entry(secret, issuer, name,
        period: period, length: length, type: _type, algorithm: _algorithm);

    save(entry);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(children: [
                Row(
                  children: [
                    const Icon(Icons.fingerprint_outlined, color: Colors.grey),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButton<OTPType>(
                        hint: Text(Translations.of(context)!.field_type),
                        isExpanded: true,
                        onChanged: (type) {
                          setState(() {
                            if (type != null) {
                              _type = type;
                            }
                          });
                        },
                        value: _type,
                        items: [
                          DropdownMenuItem(
                              value: OTPType.totp,
                              child: Text(
                                  Translations.of(context)!.otp_type_totp)),
                          DropdownMenuItem(
                              value: OTPType.hotp,
                              child:
                                  Text(Translations.of(context)!.otp_type_hotp))
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      icon: const Icon(Icons.edit_outlined),
                      labelText: Translations.of(context)!.field_name),
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                TextField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        icon: const Icon(Icons.badge_outlined),
                        labelText: Translations.of(context)!.field_issuer),
                    controller: _issuerController),
                const SizedBox(height: 16),
                TextField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        icon: const Icon(Icons.vpn_key_outlined),
                        labelText: Translations.of(context)!.field_secret),
                    controller: _secretController),
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
                                    Translations.of(context)!.field_period)),
                        const SizedBox(height: 16),
                        TextField(
                            controller: _lengthController,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                icon: const Icon(Icons.password_outlined),
                                labelText:
                                    Translations.of(context)!.field_length)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.code, color: Colors.grey),
                            const SizedBox(width: 16),
                            Expanded(
                                child: DropdownButton<Algorithm>(
                              value: _algorithm,
                              isExpanded: true,
                              hint: Text(
                                  Translations.of(context)!.field_algorithm),
                              items: [
                                DropdownMenuItem(
                                    value: Algorithm.SHA1,
                                    child: Text(Translations.of(context)!
                                        .algorithm_type_sha1)),
                                DropdownMenuItem(
                                    value: Algorithm.SHA256,
                                    child: Text(Translations.of(context)!
                                        .algorithm_type_sha256)),
                                DropdownMenuItem(
                                    value: Algorithm.SHA512,
                                    child: Text(Translations.of(context)!
                                        .algorithm_type_sha512))
                              ],
                              onChanged: (algorithm) {
                                setState(() {
                                  if (algorithm != null) {
                                    _algorithm = algorithm;
                                  }
                                });
                              },
                            ))
                          ],
                        )
                      ]),
                    )),
                const SizedBox(height: 16),
              ]),
            ),
          ));
    });
  }
}
