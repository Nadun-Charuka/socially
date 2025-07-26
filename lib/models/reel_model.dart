import 'package:cloud_firestore/cloud_firestore.dart';

class ReelModel {
  final String caption;
  final String videoUrl;
  final String userId;
  final String reelId;
  final String userName;
  final String userProfileImg;
  final DateTime datePublished;

  ReelModel({
    required this.caption,
    required this.videoUrl,
    required this.userId,
    required this.reelId,
    required this.datePublished,
    required this.userName,
    required this.userProfileImg,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      caption: json['caption'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      userId: json['userId'] ?? '',
      reelId: json['reelId'] ?? '',
      datePublished: (json['datePublished'] as Timestamp).toDate(),
      userName: json['userName'] ?? '',
      userProfileImg: json['userProfileImg'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'videoUrl': videoUrl,
      'userId': userId,
      'reelId': reelId,
      'datePublished': Timestamp.fromDate(datePublished),
      'userName': userName,
      'userProfileImg': userProfileImg,
    };
  }
}
