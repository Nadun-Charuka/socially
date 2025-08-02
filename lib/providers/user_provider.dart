import 'package:cloud_firestore/cloud_firestore.dart';
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

/// 🔁 Stream the list of userIds who follow [userId]
final followersProvider =
    StreamProvider.family<List<String>, String>((ref, userId) {
  final collection = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('followers');

  return collection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => doc.id).toList();
  });
});

/// 🔁 Stream the list of userIds whom [userId] is following
final followingProvider =
    StreamProvider.family<List<String>, String>((ref, userId) {
  final collection = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('following');

  return collection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => doc.id).toList();
  });
});
final isFollowingProvider =
    StreamProvider.family<bool, (String currentUserId, String targetUserId)>(
        (ref, tuple) {
  final (currentUserId, targetUserId) = tuple;
  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserId)
      .collection('following')
      .doc(targetUserId);

  return docRef.snapshots().map((docSnap) => docSnap.exists);
});
