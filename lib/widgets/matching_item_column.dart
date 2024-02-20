// widgets/matching_item_column.dart

import 'package:flutter/material.dart';
import 'matching_item.dart';

class MatchingItemColumn extends StatelessWidget {
  final List<String> items;

  const MatchingItemColumn({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) => MatchingItem(text: item)).toList(),
    );
  }
}