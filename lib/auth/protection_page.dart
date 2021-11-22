import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class ProtectionPage extends StatefulWidget {
  const ProtectionPage({Key? key}) : super(key: key);

  @override
  _ProtectionPageState createState() => _ProtectionPageState();
}

class _ProtectionPageState extends State<ProtectionPage> {
  final _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.admin_panel_settings_outlined,
                            size: 32),
                        Text(
                            Translations.of(context)!
                                .title_setup_app_protection,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18)),
                        const SizedBox(height: 8),
                        Text(
                          Translations.of(context)!
                              .title_setup_app_protection_subtitle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
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
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                            onPressed: () {},
                            child:
                                Text(Translations.of(context)!.button_continue))
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context, false);
    return Future.value(true);
  }
}
