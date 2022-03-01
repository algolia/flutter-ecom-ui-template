import 'package:flutter/material.dart';

class HistoryRowView extends StatelessWidget {
  const HistoryRowView({Key? key, required this.suggestion, this.onRemove})
      : super(key: key);

  final String suggestion;
  final Function(String)? onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Icon(Icons.refresh),
      const SizedBox(
        width: 10,
      ),
      Text(suggestion, style: const TextStyle(fontSize: 16)),
      const Spacer(),
      IconButton(
          onPressed: () => onRemove?.call(suggestion),
          icon: const Icon(Icons.close)),
    ]);
  }
}
