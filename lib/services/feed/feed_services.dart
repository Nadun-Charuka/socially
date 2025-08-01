import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:socially/models/post_model.dart';

class FeedServices {
  final CollectionReference _feedCollection =
      FirebaseFirestore.instance.collection("feeds");

  Future<void> savePost(PostModel post) async {
    try {
      await _feedCollection.doc(post.postId).set(post.toJson());
      debugPrint("reel saved sucessfully");
    } catch (e) {
      debugPrint("Error saving post: $e");
    }
  }

//upload post
  Future<String?> uploadPostImage(File imageFile, String uid) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('posts')
          .child('$uid-${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading post image: $e');
      return null;
    }
  }

  Stream<List<PostModel>> getPostStream() {
    return _feedCollection
        .orderBy('datePublished', descending: true)
        .snapshots()
        .map((snapshot) {
      // debugPrint("🔥 Got ${snapshot.docs.length} posts");
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return PostModel.fromJson(data);
      }).toList();
    });
  }

  Stream<List<PostModel>> getPostById(String userId) {
    return _feedCollection.where('userId', isEqualTo: userId).snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return PostModel.fromJson(doc.data() as Map<String, dynamic>);
          },
        ).toList();
      },
    );
  }

  Stream<PostModel> getSinglePostStream(String postId) {
    return _feedCollection.doc(postId).snapshots().map(
          (doc) => PostModel.fromJson(doc.data()! as Map<String, dynamic>),
        );
  }

  Future<void> deletePost(String postId, String postUrl) async {
    await _feedCollection.doc(postId).delete();
    await FirebaseStorage.instance.refFromURL(postUrl).delete();
  }

  Stream<bool> hasUserLikedStream({
    required String postId,
    required String userId,
  }) {
    return _feedCollection
        .doc(postId)
        .collection("likes")
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final postLikesRef =
          _feedCollection.doc(postId).collection('likes').doc(userId);

      await postLikesRef.set({'likedAt': Timestamp.now()});
      await _feedCollection.doc(postId).update({
        'likes': FieldValue.increment(1),
      });

      debugPrint('Post liked successfully');
    } catch (error) {
      debugPrint('Error liking post: $error');
    }
  }

  Future<void> unlikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final postLikesRef =
          _feedCollection.doc(postId).collection('likes').doc(userId);

      await postLikesRef.delete();
      await _feedCollection.doc(postId).update({
        'likes': FieldValue.increment(-1),
      });

      debugPrint('Post unliked successfully');
    } catch (error) {
      debugPrint('Error unliking post: $error');
    }
  }

  Future<bool> hasUserLikedPost(
      {required String postId, required String userId}) async {
    try {
      final DocumentReference postLikeRef =
          _feedCollection.doc(postId).collection("likes").doc(userId);
      final snapshot = await postLikeRef.get();
      return snapshot.exists;
    } catch (e) {
      debugPrint('Error checking if the user liked the post: $e');
      return false;
    }
  }
}
