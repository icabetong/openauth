import 'package:flutter/material.dart';

class PreferenceList extends StatelessWidget {
  const PreferenceList({
    Key? key,
    this.items = const [],
  }) : super(key: key);

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return items[index];
        },
        childCount: items.length,
      ),
    );
  }
}

class PreferenceGroup extends StatelessWidget {
  const PreferenceGroup({
    Key? key,
    this.tiles = const [],
    this.header,
    this.headerTextStyle,
  }) : super(key: key);

  final List<PreferenceTile> tiles;
  final String? header;
  final TextStyle? headerTextStyle;

  TextStyle _getHeaderStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              header!,
              style: headerTextStyle ?? _getHeaderStyle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            return tiles[index];
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: tiles.length,
        )
      ],
    );
  }
}

enum _PreferenceTileType {
  normalTile,
  switchTile,
  checkboxTile,
}

class PreferenceTile extends StatelessWidget {
  static const _titleMaxLines = 2;
  static const _subtitleMaxLines = 2;

  const PreferenceTile({
    Key? key,
    required this.title,
    this.titleMaxLines,
    this.subtitle,
    this.subtitleMaxLines,
    this.leading,
    this.trailing,
    this.onPressed,
    this.enabled = true,
    this.titleTextStyle,
    this.subtitleTextStyle,
  })  : _tileType = _PreferenceTileType.normalTile,
        onToggle = null,
        checked = null,
        // assert(titleMaxLines == null || titleMaxLines > 0),
        // assert(subtitleMaxLines == null || subtitleMaxLines > 0),
        super(key: key);

  final String title;
  final int? titleMaxLines;
  final String? subtitle;
  final int? subtitleMaxLines;
  final Widget? leading;
  final Widget? trailing;
  final Function(BuildContext context)? onPressed;
  final Function(bool isChecked)? onToggle;
  final bool? checked;
  final bool enabled;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final _PreferenceTileType _tileType;

  const PreferenceTile.switchTile({
    Key? key,
    required this.title,
    this.titleMaxLines = _titleMaxLines,
    this.subtitle,
    this.subtitleMaxLines = _subtitleMaxLines,
    this.leading,
    this.enabled = true,
    this.trailing,
    required this.onToggle,
    required this.checked,
    this.titleTextStyle,
    this.subtitleTextStyle,
  })  : _tileType = _PreferenceTileType.switchTile,
        onPressed = null,
        assert(titleMaxLines == null || titleMaxLines > 0),
        assert(subtitleMaxLines == null || subtitleMaxLines > 0),
        super(key: key);

  const PreferenceTile.checkBoxTile({
    Key? key,
    required this.title,
    this.titleMaxLines = _titleMaxLines,
    this.subtitle,
    this.subtitleMaxLines = _subtitleMaxLines,
    this.leading,
    this.enabled = true,
    this.trailing,
    required this.onToggle,
    required this.checked,
    this.titleTextStyle,
    this.subtitleTextStyle,
  })  : _tileType = _PreferenceTileType.switchTile,
        onPressed = null,
        assert(titleMaxLines == null || titleMaxLines > 0),
        assert(subtitleMaxLines == null || subtitleMaxLines > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (_tileType) {
      case _PreferenceTileType.normalTile:
        return ListTile(
          title: Text(title, style: titleTextStyle ?? _titleTextStyle),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: subtitleTextStyle ?? _subtitleTextStyle,
                  maxLines: subtitleMaxLines ?? _subtitleMaxLines,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          leading: leading,
          trailing: trailing,
          enableFeedback: enabled,
          onTap: () {
            onPressed?.call(context);
          },
        );
      case _PreferenceTileType.switchTile:
        return SwitchListTile(
          activeColor: Theme.of(context).colorScheme.primary,
          secondary: leading,
          value: checked!,
          onChanged: enabled ? onToggle : null,
          title: Text(
            title,
            style: titleTextStyle ?? _titleTextStyle,
            maxLines: titleMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: subtitleTextStyle ?? _subtitleTextStyle,
                  maxLines: subtitleMaxLines,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
        );
      case _PreferenceTileType.checkboxTile:
        return CheckboxListTile(
          activeColor: Theme.of(context).colorScheme.primary,
          secondary: leading,
          value: checked!,
          onChanged: enabled && onToggle != null
              ? (checked) {
                  onToggle!(checked ?? false);
                }
              : null,
          title: Text(
            title,
            style: titleTextStyle ?? _titleTextStyle,
            maxLines: titleMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: subtitleTextStyle ?? _subtitleTextStyle,
                  maxLines: subtitleMaxLines,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
        );
    }
  }

  TextStyle get _titleTextStyle =>
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 16);
  TextStyle get _subtitleTextStyle => const TextStyle(color: Colors.grey);
}
