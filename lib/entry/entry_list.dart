import 'dart:async';
import 'package:base32/base32.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:openauth/database/notifier.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/shared/countdown.dart';
import 'package:openauth/shared/token.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

enum EntryListAction { edit, remove }

class EntryList extends StatelessWidget {
  const EntryList({
    Key? key,
    required this.entries,
    this.enableDragging = true,
    this.onTap,
    required this.onLongTap,
  }) : super(key: key);
  final List<Entry> entries;
  final bool enableDragging;
  final Function(String)? onTap;
  final Function(Entry) onLongTap;

  @override
  Widget build(BuildContext context) {
    return entries.isNotEmpty
        ? ReorderableSliverList(
            delegate: ReorderableSliverChildBuilderDelegate(
              (context, index) {
                return EntryListTile(
                  key: Key(entries[index].entryId),
                  entry: entries[index],
                  onTap: onTap,
                  onLongTap: onLongTap,
                );
              },
              childCount: entries.length,
            ),
            onReorder: (from, to) async {
              await Provider.of<EntryNotifier>(context, listen: false)
                  .reorder(entries[from], from, to);
            },
            enabled: enableDragging,
          )
        : const EntryEmptyState();
  }
}

class EntryListTile extends StatefulWidget {
  const EntryListTile({
    Key? key,
    required this.entry,
    this.onTap,
    required this.onLongTap,
  }) : super(key: key);
  final Entry entry;
  final Function(String)? onTap;
  final Function(Entry) onLongTap;

  @override
  State<EntryListTile> createState() => _EntryListTileState();
}

class _EntryListTileState extends State<EntryListTile> {
  Exception? exception;
  CountDown? countdown;
  StreamSubscription<Duration>? subscription;
  String? code;
  int time = 0;

  @override
  void initState() {
    super.initState();

    switch (widget.entry.type) {
      case OTPType.steam:
      case OTPType.totp:
        _startTOTPGeneration();
        break;
      case OTPType.hotp:
        _startHOTPGeneration();
        break;
    }
  }

  void _startTOTPGeneration() {
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

  void _startHOTPGeneration({bool increment = false}) {
    if (increment) {
      widget.entry.counter++;
      Provider.of<EntryNotifier>(context, listen: false).put(widget.entry);
    }
    setState(() => _generate());
  }

  void _countdown() {
    subscription = countdown?.stream?.listen(null);
    subscription?.onDone(() {
      _startTOTPGeneration();
    });

    subscription?.onData((data) {
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
    try {
      base32.decode(widget.entry.secret);
      code = TokenGenerator.compute(widget.entry);
    } on FormatException catch (exception) {
      this.exception = exception;
      countdown = null;
      subscription?.cancel();
    }
  }

  Widget _getLeading() {
    switch (widget.entry.type) {
      case OTPType.totp:
        double progress = time / 30;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(value: progress),
        );
      case OTPType.hotp:
        return IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            _startHOTPGeneration(increment: true);
          },
        );
      case OTPType.steam:
        double progress = time / 30;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(value: progress),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: widget.key,
      leading: SizedBox(
        child: exception is FormatException ? null : _getLeading(),
        width: 40,
        height: 40,
      ),
      trailing: GestureDetector(
        child: const Icon(Icons.more_vert_outlined),
        onTap: () {
          widget.onLongTap(widget.entry);
        },
      ),
      title: Text(code ?? Translations.of(context)!.error_secret_invalid,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
      subtitle: Text(widget.entry.name + " - " + widget.entry.issuer),
      onTap: () {
        if (code != null && widget.onTap != null) widget.onTap!(code!);
      },
    );
  }
}

class EntryEmptyState extends StatelessWidget {
  const EntryEmptyState({Key? key}) : super(key: key);

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
