import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/services/auth/auth_services.dart';
import 'package:socially/services/user/user_services.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final userServiceProvider = Provider((ref) => UserService());

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).authStateChanges,
);

final appUserProvider = StreamProvider<AppUser?>((ref) {
  final firebaseUser = ref.watch(authStateProvider).value;
  final userService = ref.watch(userServiceProvider);

  if (firebaseUser == null) return Stream.value(null);
  return userService.getUserById(firebaseUser.uid);
});
