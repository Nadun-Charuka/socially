import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/providers/feed_provider.dart';
import 'package:socially/widgets/main/post/post_widget.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedStreamProvider);

    return Scaffold(
      body: feedAsync.when(
        data: (posts) {
          return posts.isNotEmpty
              ? SingleChildScrollView(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16),
                        child: PostWidget(post: post),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text("No Feeds"),
                );
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, st) => Text("Error loading feed: $e"),
      ),
    );
  }
}
