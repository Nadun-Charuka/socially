import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/providers/feed_provider.dart';
import 'package:socially/widgets/main/post/post_widget.dart';

class SinglePostScreen extends ConsumerWidget {
  final String postId;

  const SinglePostScreen({required this.postId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(singleFeedProvider(postId));

    return Scaffold(
      appBar: AppBar(title: Text("Post")),
      body: postAsync.when(
        data: (post) => SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: PostWidget(post: post),
        )),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
