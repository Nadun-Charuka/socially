import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:socially/models/reel_model.dart';

class ReelsService {
  final CollectionReference _reelsCollection =
      FirebaseFirestore.instance.collection("reels");

  Future<void> saveReel(ReelModel reel) async {
    try {
      _reelsCollection.doc().set(reel.toJson());
    } catch (e) {
      debugPrint("error in reel save :$e");
    }
  }

  Future<String> uploadVideo(
      {required File videoFile, required String userId}) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("reels")
          .child("$userId-${DateTime.now().millisecondsSinceEpoch}.mp4");
      await ref.putFile(videoFile);
      return ref.getDownloadURL();
    } catch (e) {
      debugPrint("error in uploading video $e");
      return "";
    }
  }

  Stream<List<ReelModel>> getReelsStream() {
    return _reelsCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            final data = doc.data() as Map<String, dynamic>;

            return ReelModel.fromJson(data);
          },
        ).toList();
      },
    );
  }

  Future<void> deletReel(String reelId, String videoUrl) async {
    await _reelsCollection.doc(reelId).delete();
    await FirebaseStorage.instance.refFromURL(videoUrl).delete();
  }
}
