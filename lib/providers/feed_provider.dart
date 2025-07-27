import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/models/post_model.dart';
import 'package:socially/providers/user_provider.dart';
import 'package:socially/services/feed/feed_services.dart';

final feedProvider = Provider<FeedServices>((ref) {
  return FeedServices();
});

final feedStreamProvider = StreamProvider<List<PostModel>>((ref) {
  final feedServices = ref.watch(feedProvider);
  return feedServices.getPostStream();
});

final feedByIdProvider =
    StreamProvider.family<List<PostModel>, String>((ref, String userId) {
  final feedServices = ref.watch(feedProvider);
  return feedServices.getPostById(userId);
});

final singleFeedProvider =
    StreamProvider.family<PostModel, String>((ref, postId) {
  final feedServices = ref.watch(feedProvider);
  return feedServices.getSinglePostStream(postId);
});

final hasUserLikedProvider = StreamProvider.family<bool, String>((ref, postId) {
  final feedService = ref.watch(feedProvider);
  final userId = ref.watch(appUserProvider).value?.uid;

  if (userId == null) return Stream<bool>.value(false);
  return feedService.hasUserLikedStream(postId: postId, userId: userId);
});
