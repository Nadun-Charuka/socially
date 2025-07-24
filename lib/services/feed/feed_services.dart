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
    } catch (e) {
      debugPrint("Error saving post: $e");
    }
  }

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
    return _feedCollection.snapshots().map((snapshot) {
      debugPrint("🔥 Got ${snapshot.docs.length} posts");
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        debugPrint("📄 Post: ${data.toString()}");
        return PostModel.fromJson(data);
      }).toList();
    });
  }

  Future<void> deletePost(String postId) async {
    await _feedCollection.doc(postId).delete();
  }
}
