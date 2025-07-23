import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socially/services/auth/auth_services.dart';
import 'package:socially/services/user/user_services.dart';

import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).authStateChanges,
);

final appUserProvider = FutureProvider<AppUser?>((ref) async {
  final auth = ref.watch(authStateProvider).value;
  if (auth == null) return null;

  final userService = UserService();
  return await userService.getUserById(auth.uid);
});
