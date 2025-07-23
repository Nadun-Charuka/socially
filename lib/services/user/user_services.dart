import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socially/models/user_model.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  Future<void> createUserProfile(
      User user, String name, bool isGoogleUser) async {
    final docRef = _db.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final newUser = AppUser(
        uid: user.uid,
        email: user.email ?? '',
        name: name,
        photoUrl: user.photoURL ?? '',
        isGoogleUser: isGoogleUser,
      );
      await docRef.set(newUser.toMap());
    }
  }

  Future<AppUser?> getUserById(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!);
    }
    return null;
  }
}
