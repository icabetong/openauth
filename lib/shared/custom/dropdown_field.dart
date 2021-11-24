import 'package:flutter/material.dart';

class DropdownInputField<T> extends StatelessWidget {
  const DropdownInputField({
    Key? key,
    required this.selected,
    required this.items,
    required this.onChange,
    this.hintText,
    this.labels,
  }) : super(key: key);

  final T selected;
  final List<T> items;
  final List<String>? labels;
  final String? hintText;
  final Function(T) onChange;

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      builder: (FormFieldState<T> state) {
        return InputDecorator(
          decoration: InputDecoration(
              errorStyle: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 16.0),
              hintText: hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          isEmpty: selected == null,
          child: DropdownButtonHideUnderline(
            child: Theme(
              data: Theme.of(context)
                  .copyWith(canvasColor: Theme.of(context).colorScheme.surface),
              child: DropdownButton<T>(
                value: selected,
                isDense: true,
                onChanged: (T? newValue) {
                  onChange(newValue ?? selected!);
                },
                items: items.map((T value) {
                  String label = labels != null && labels!.isNotEmpty
                      ? labels![items.indexOf(value)]
                      : value.toString();

                  return DropdownMenuItem<T>(
                    value: value,
                    child: Text(label),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
