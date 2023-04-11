import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAutoValidation = StateProvider<bool>(((ref) {
  return false;
}));