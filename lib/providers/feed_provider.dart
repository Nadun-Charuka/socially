import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/models/post_model.dart';
import 'package:socially/services/feed/feed_services.dart';

final feedStreamProvider = StreamProvider<List<PostModel>>((ref) {
  final feedServices = FeedServices();
  return feedServices.getPostStream();
});

final feedByIdProvider =
    StreamProvider.family<List<PostModel>, String>((ref, String userId) {
  final feedServices = FeedServices();
  return feedServices.getPostById(userId);
});

final singlePostProvider =
    StreamProvider.family<PostModel, String>((ref, postId) {
  final feedServices = FeedServices();
  return feedServices.getSinglePostStream(postId);
});
