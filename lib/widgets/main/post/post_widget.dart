import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:socially/models/post_model.dart';
import 'package:socially/providers/feed_provider.dart';
import 'package:socially/providers/user_provider.dart';
import 'package:socially/services/auth/auth_services.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:socially/utils/functions/common.dart';
import 'package:socially/utils/functions/mood.dart';

class PostWidget extends ConsumerStatefulWidget {
  final PostModel post;
  const PostWidget({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends ConsumerState<PostWidget> {
  final currentUser = AuthService().currentUser;

  void _likeOrDisLikePost(bool isLiked) async {
    final feedService = ref.read(feedProvider);
    final userId = ref.read(appUserProvider).value?.uid;
    if (userId == null) return;

    try {
      if (isLiked) {
        await feedService.unlikePost(
            postId: widget.post.postId, userId: userId);
        if (mounted) showSnackBar(text: "Post Unliked", context: context);
      } else {
        await feedService.likePost(postId: widget.post.postId, userId: userId);
        if (mounted) showSnackBar(text: "Post Liked", context: context);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final postOwner = ref.watch(getUserByIdProvider(widget.post.userId));
    final hasLikedAsync = ref.watch(hasUserLikedProvider(widget.post.postId));
    final appUserAsyncValue = ref.watch(appUserProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                width: 40,
                height: 40,
                imageUrl: widget.post.profImage,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: Text(
                    widget.post.username,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    GoRouter.of(context)
                        .push('/single-user-screen', extra: postOwner.value);
                  },
                ),
                Text(
                  DateFormat("dd-MM-yyyy : hh:mm: a")
                      .format(widget.post.datePublished),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: mainPurpleColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 5,
            ),
            child: Text(
              'Feeling ${widget.post.mood.name} ${widget.post.mood.emoji}',
            ),
          ),
        ),
        Text(
          widget.post.postCaption,
        ),
        CachedNetworkImage(
          imageUrl: widget.post.postUrl,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Row(
          children: [
            hasLikedAsync.when(
              data: (isLiked) => IconButton(
                onPressed: () {
                  _likeOrDisLikePost(isLiked); // pass value from stream
                },
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                  color: isLiked ? Colors.pink : null,
                ),
              ),
              loading: () => IconButton(
                  onPressed: null, icon: Icon(Icons.favorite_border)),
              error: (_, __) =>
                  IconButton(onPressed: null, icon: Icon(Icons.error)),
            ),
            Text(widget.post.likes.toString()),
            Spacer(),
            if (widget.post.userId == appUserAsyncValue.value?.uid)
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            _buildDialogOption(
                              context: context,
                              icon: Icons.edit,
                              text: "Edit",
                              onTap: () {},
                            ),
                            Divider(),
                            _buildDialogOption(
                              context: context,
                              icon: Icons.delete,
                              text: 'Delete',
                              onTap: () async {
                                final feedService = ref.read(feedProvider);
                                await feedService.deletePost(
                                  widget.post.postId,
                                  widget.post.postUrl,
                                );
                                if (context.mounted) {
                                  showSnackBar(
                                    text: "Post Deleted",
                                    context: context,
                                  );
                                }
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.more_vert),
              )
          ],
        )
      ],
    );
  }
}

Widget _buildDialogOption({
  required BuildContext context,
  required IconData icon,
  required String text,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: mainWhiteColor,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: mainWhiteColor,
                ),
          ),
        ],
      ),
    ),
  );
}
