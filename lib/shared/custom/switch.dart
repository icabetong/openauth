import 'package:flutter/material.dart';

class SwitchField extends StatelessWidget {
  const SwitchField(
      {Key? key,
      required this.checked,
      required this.onChange,
      required this.labelText})
      : super(key: key);

  final bool checked;
  final Function(bool) onChange;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChange(!checked);
      },
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(labelText)),
          Expanded(
              flex: 1,
              child: Switch(
                activeColor: Theme.of(context).colorScheme.primary,
                value: checked,
                onChanged: onChange,
              ))
        ],
      ),
    );
  }
}
