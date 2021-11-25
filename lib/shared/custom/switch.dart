import 'package:flutter/material.dart';

class SwitchField extends StatelessWidget {
  const SwitchField(
      {Key? key,
      required this.checked,
      required this.onChange,
      required this.labelText,
      this.enabled = true})
      : super(key: key);

  final bool checked;
  final bool enabled;
  final Function(bool) onChange;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () {
              onChange(!checked);
            }
          : null,
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              labelText,
              style: TextStyle(
                  color: enabled
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.grey),
            ),
          ),
          Expanded(
              flex: 1,
              child: Switch(
                activeColor: Theme.of(context).colorScheme.primary,
                value: checked,
                onChanged: enabled ? onChange : null,
              ))
        ],
      ),
    );
  }
}
