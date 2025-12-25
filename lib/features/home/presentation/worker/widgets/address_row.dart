import 'package:flutter/material.dart';

class AddressRow extends StatelessWidget {
  final String start;
  final String end;

  const AddressRow({
    super.key,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.circle, size: 12, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(child: Text(start, style: const TextStyle(color: Colors.black87, fontSize: 13))),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 5.5),
          padding: const EdgeInsets.symmetric(vertical: 2),
          alignment: Alignment.centerLeft,
          child: Container(
            height: 12,
            width: 1,
            color: Colors.grey[300],
          ),
        ),
        Row(
          children: [
            const Icon(Icons.circle, size: 12, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(child: Text(end, style: const TextStyle(color: Colors.black87, fontSize: 13))),
          ],
        ),
      ],
    );
  }
}
