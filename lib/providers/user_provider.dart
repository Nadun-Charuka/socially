import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/providers/auth_provider.dart';

final appUserProvider = StreamProvider<UserModel?>((ref) {
  final firebaseUser = ref.watch(authStateProvider).value;
  final userService = ref.watch(userServiceProvider);

  if (firebaseUser == null) return Stream.value(null);
  return userService.getUserById(firebaseUser.uid);
});

final getUserByIdProvider =
    StreamProvider.family<UserModel?, String>((ref, String userId) {
  final userService = ref.watch(userServiceProvider);
  return userService.getUserById(userId);
});
