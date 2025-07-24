import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/models/post_model.dart';
import 'package:socially/services/feed/feed_services.dart';

final feedStreamProvider = StreamProvider<List<PostModel>>((ref) {
  final feedServices = FeedServices();
  return feedServices.getPostStream();
});
