import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current search text entered by the user.
final habitSearchProvider = StateProvider<String>(
  (ref) => '',
);
