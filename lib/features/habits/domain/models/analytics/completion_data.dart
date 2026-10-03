import 'package:flutter/foundation.dart';

@immutable
class CompletionData {
  const CompletionData({
    required this.date,
    required this.value,
  });

  final DateTime date;

  final int value;
}