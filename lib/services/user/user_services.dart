import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:socially/models/user_model.dart';

class UserService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("users");

  final _storage = FirebaseStorage.instance;

  Future<void> saveUser(User user, String name, bool isGoogleUser,
      {String? photoUrl}) async {
    final docRef = _userCollection.doc(user.uid);
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
      final data = doc.data() as Map<String, dynamic>; // ✅ cast here
      if (isGoogleUser &&
          user.photoURL != null &&
          data['photoUrl'] != user.photoURL) {
        await docRef.update({'photoUrl': user.photoURL});
      }
    }
  }

  Stream<UserModel?> getUserById(String uid) {
    return _userCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromJson(doc.data()! as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _userCollection.get();
      return snapshot.docs
          .map(
            (doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      debugPrint("error in user fetching for search user: $e");
      return [];
    }
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

  /// Follow a user
  Future<void> followUser({
    required String currentUserId,
    required String userToFollow,
  }) async {
    try {
      final currentUserRef = _userCollection.doc(currentUserId);
      final followedUserRef = _userCollection.doc(userToFollow);

      final followersRef =
          followedUserRef.collection("followers").doc(currentUserId);
      final followingRef =
          currentUserRef.collection("following").doc(userToFollow);

      // Prevent duplicate follow
      final alreadyFollowed = await followersRef.get();
      if (alreadyFollowed.exists) {
        debugPrint("Already following this user.");
        return;
      }

      await followersRef.set({'FollowedAt': Timestamp.now()});
      await followingRef.set({'FollowedAt': Timestamp.now()});

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final followedSnap = await transaction.get(followedUserRef);
        final currentSnap = await transaction.get(currentUserRef);

        final followedData = followedSnap.data() as Map<String, dynamic>;
        final currentData = currentSnap.data() as Map<String, dynamic>;

        final newFollowerCount = (followedData['followers'] ?? 0) + 1;
        final newFollowingCount = (currentData['following'] ?? 0) + 1;

        transaction.update(followedUserRef, {'followers': newFollowerCount});
        transaction.update(currentUserRef, {'following': newFollowingCount});
      });

      debugPrint('✅ Followed successfully');
    } catch (e) {
      debugPrint('❌ Error in followUser: $e');
    }
  }

  /// ✅ Unfollow a user
  Future<void> unfollowUser({
    required String currentUserId,
    required String userToUnfollow,
  }) async {
    try {
      final currentUserRef = _userCollection.doc(currentUserId);
      final unfollowedUserRef = _userCollection.doc(userToUnfollow);

      final followersRef =
          unfollowedUserRef.collection("followers").doc(currentUserId);
      final followingRef =
          currentUserRef.collection("following").doc(userToUnfollow);

      await followersRef.delete();
      await followingRef.delete();

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final unfollowedSnap = await transaction.get(unfollowedUserRef);
        final currentSnap = await transaction.get(currentUserRef);

        final unfollowedData = unfollowedSnap.data() as Map<String, dynamic>;
        final currentData = currentSnap.data() as Map<String, dynamic>;

        final updatedFollowers = (unfollowedData['followers'] ?? 0) - 1;
        final updatedFollowing = (currentData['following'] ?? 0) - 1;

        transaction.update(unfollowedUserRef, {
          'followers': updatedFollowers < 0 ? 0 : updatedFollowers,
        });
        transaction.update(currentUserRef, {
          'following': updatedFollowing < 0 ? 0 : updatedFollowing,
        });
      });

      debugPrint('✅ Unfollowed successfully');
    } catch (e) {
      debugPrint('❌ Error in unfollowUser: $e');
    }
  }

  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    final followingRef = _userCollection
        .doc(currentUserId)
        .collection("following")
        .doc(targetUserId);
    return (await followingRef.get()).exists;
  }
}
