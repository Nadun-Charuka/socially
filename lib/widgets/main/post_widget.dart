import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:socially/models/post_model.dart';
import 'package:socially/providers/auth_provider.dart';
import 'package:socially/services/feed/feed_services.dart';
import 'package:socially/utils/constants/colors.dart';
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
  @override
  Widget build(BuildContext context) {
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
                Text(
                  widget.post.username,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border_outlined,
              ),
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
                                await FeedServices()
                                    .deletePost(widget.post.postId);
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
