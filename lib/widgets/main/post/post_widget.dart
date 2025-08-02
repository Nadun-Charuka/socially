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
  const PostWidget({super.key, required this.post});

  @override
  ConsumerState<PostWidget> createState() => _PostWidgetState();
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
    final appUserAsync = ref.watch(appUserProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PostHeader(
          username: widget.post.username,
          userImageUrl: widget.post.profImage,
          datePublished: widget.post.datePublished,
          onTapProfile: () {
            GoRouter.of(context)
                .push('/single-user-screen', extra: postOwner.value);
          },
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          decoration: BoxDecoration(
            color: mainPurpleColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
              'Feeling ${widget.post.mood.name} ${widget.post.mood.emoji}'),
        ),
        const SizedBox(height: 6),
        Text(widget.post.postCaption),
        const SizedBox(height: 8),
        CachedNetworkImage(
          imageUrl: widget.post.postUrl,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.6,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            hasLikedAsync.when(
              data: (isLiked) => IconButton(
                onPressed: () => _likeOrDisLikePost(isLiked),
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                  color: isLiked ? Colors.pink : null,
                ),
              ),
              loading: () => const IconButton(
                  onPressed: null, icon: Icon(Icons.favorite_border)),
              error: (_, __) =>
                  const IconButton(onPressed: null, icon: Icon(Icons.error)),
            ),
            Text(widget.post.likes.toString()),
            const Spacer(),
            if (widget.post.userId == appUserAsync.value?.uid)
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showPostOptions(context),
              ),
          ],
        ),
      ],
    );
  }

  void _showPostOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ListView(
          shrinkWrap: true,
          children: [
            _DialogOption(
              icon: Icons.edit,
              text: "Edit",
              onTap: () {},
            ),
            const Divider(),
            _DialogOption(
              icon: Icons.delete,
              text: "Delete",
              onTap: () async {
                final feedService = ref.read(feedProvider);
                await feedService.deletePost(
                  widget.post.postId,
                  widget.post.postUrl,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                  showSnackBar(text: "Post Deleted", context: context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final String username;
  final String userImageUrl;
  final DateTime datePublished;
  final VoidCallback onTapProfile;

  const _PostHeader({
    required this.username,
    required this.userImageUrl,
    required this.datePublished,
    required this.onTapProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: CachedNetworkImage(
            width: 40,
            height: 40,
            imageUrl: userImageUrl,
            errorWidget: (context, url, error) => const Icon(Icons.person),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTapProfile,
              child: Text(
                username,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              DateFormat("dd-MM-yyyy : hh:mm a").format(datePublished),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class _DialogOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _DialogOption({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: mainWhiteColor),
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
}
