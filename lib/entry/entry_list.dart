import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/database/notifier.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/shared/countdown.dart';
import 'package:openauth/shared/token.dart';
import 'package:provider/provider.dart';

enum EntryListAction { edit, remove }

class EntryList extends StatelessWidget {
  const EntryList(
      {Key? key,
      required this.entries,
      required this.onTap,
      required this.onLongPress})
      : super(key: key);
  final List<Entry> entries;
  final Function(String) onTap;
  final Function(Entry) onLongPress;

  void _onRemove(BuildContext context, Entry entry) async {
    final result =
        await Provider.of<EntryNotifier>(context, listen: false).remove(entry);
    debugPrint(result);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return EntryListTile(
          key: Key(entries[index].entryId),
          entry: entries[index],
          onRemove: (entry) {
            _onRemove(context, entry);
          },
          onTap: onTap,
          onLongPress: onLongPress,
        );
      }, childCount: entries.length),
    );
  }
}

class EntryListTile extends StatefulWidget {
  const EntryListTile(
      {Key? key,
      required this.entry,
      required this.onRemove,
      required this.onTap,
      required this.onLongPress})
      : super(key: key);
  final Entry entry;
  final Function(Entry) onRemove;
  final Function(String) onTap;
  final Function(Entry) onLongPress;

  @override
  State<EntryListTile> createState() => _EntryListTileState();
}

class _EntryListTileState extends State<EntryListTile> {
  CountDown? countdown;
  String? code;
  int time = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    final seconds = DateTime.now().second;
    if (seconds == 0) {
      countdown = CountDown(const Duration(seconds: 30));
      _countdown();
    } else if (seconds > 1 && seconds <= 30) {
      countdown = CountDown(Duration(seconds: seconds));
      _countdown();
    } else if (seconds >= 31 && seconds <= 60) {
      countdown = CountDown(Duration(seconds: 30 - (seconds - 30)));
      _countdown();
    }
  }

  void _countdown() {
    final sub = countdown?.stream?.listen(null);
    sub?.onDone(() {
      _start();
    });

    sub?.onData((data) {
      if (mounted) {
        setState(() {
          time = data.inSeconds;
          if (time == 0 || code == null) {
            _generate();
          }
        });
      }
    });
  }

  void _generate() {
    code = TokenGenerator.compute(widget.entry);
  }

  @override
  Widget build(BuildContext context) {
    double progress = time / 30;
    return ListTile(
      key: widget.key,
      leading: CircularProgressIndicator(value: progress),
      title: Text(code ?? Translations.of(context)!.error_code_not_found,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
      subtitle: Text(widget.entry.name + " - " + widget.entry.issuer),
      onTap: () {
        if (code != null) widget.onTap(code!);
      },
      onLongPress: () {
        widget.onLongPress(widget.entry);
      },
    );
  }
}

class EmptyEntry extends StatelessWidget {
  const EmptyEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Translations.of(context)!.empty_accounts,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(Translations.of(context)!.empty_accounts_subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500))
            ],
          ),
        ));
  }
}
