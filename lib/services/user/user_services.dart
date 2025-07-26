import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:socially/models/user_model.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  final _storage = FirebaseStorage.instance;

  Future<void> saveUser(User user, String name, bool isGoogleUser,
      {String? photoUrl}) async {
    final docRef = _db.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final newUser = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: name,
        photoUrl: photoUrl ?? '',
        isGoogleUser: isGoogleUser,
      );
      await docRef.set(newUser.toJson());
    } else {
      if (isGoogleUser &&
          user.photoURL != null &&
          doc.data()?['photoUrl'] != user.photoURL) {
        await docRef.update({'photoUrl': user.photoURL});
      }
    }
  }

  Stream<UserModel?> getUserById(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      } else {
        return null;
      }
    });
  }

  Future<String?> uploadProfileImage(File imageFile, String uid) async {
    try {
      final ref = _storage.ref().child('profilePictures').child('$uid.jpg');
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }
}
