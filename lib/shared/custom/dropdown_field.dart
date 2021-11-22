import 'package:flutter/material.dart';

class DropdownInputField<T> extends StatefulWidget {
  const DropdownInputField({
    Key? key,
    required this.items,
    required this.onChange,
    this.hintText,
    this.labels,
  }) : super(key: key);

  final List<T> items;
  final List<String>? labels;
  final String? hintText;
  final Function(T) onChange;

  @override
  _DropdownInputFieldState createState() => _DropdownInputFieldState<T>();
}

class _DropdownInputFieldState<T> extends State<DropdownInputField<T>> {
  T? _selectedValue;

  @override
  Widget build(BuildContext context) {
    if (widget.hintText == null) _selectedValue = widget.items.first;

    return FormField<T>(
      builder: (FormFieldState<T> state) {
        return InputDecorator(
          decoration: InputDecoration(
              errorStyle: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 16.0),
              hintText: widget.hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          isEmpty: _selectedValue == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: _selectedValue,
              isDense: true,
              onChanged: (T? newValue) {
                setState(() {
                  _selectedValue = newValue;
                  state.didChange(newValue);
                });
              },
              items: widget.items.map((T value) {
                String label =
                    widget.labels != null && widget.labels!.isNotEmpty
                        ? widget.labels![widget.items.indexOf(value)]
                        : value.toString();

                return DropdownMenuItem<T>(
                  value: value,
                  child: Text(label),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
