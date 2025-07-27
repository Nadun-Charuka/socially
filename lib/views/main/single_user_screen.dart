import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/providers/feed_provider.dart';
import 'package:socially/widgets/reuseable/custom_button.dart';

class SingleUserScreen extends ConsumerStatefulWidget {
  final UserModel user;
  const SingleUserScreen({super.key, required this.user});

  @override
  ConsumerState<SingleUserScreen> createState() => _SingleUserScreenState();
}

class _SingleUserScreenState extends ConsumerState<SingleUserScreen> {
  final User _currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(feedByIdProvider(widget.user.uid));
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      width: 80,
                      height: 80,
                      errorWidget: (context, url, error) => Icon(Icons.person),
                      imageUrl: widget.user.photoUrl,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${widget.user.followers.toString()} followers ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              widget.user.uid != _currentUser.uid
                  ? CustomButton(
                      text: "Follow",
                      width: double.infinity,
                      onPressed: () {
                        //todo following logic
                      },
                    )
                  : Text(""),
              feedAsync.when(
                data: (posts) {
                  return posts.isNotEmpty
                      ? GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 4 / 6,
                            crossAxisCount: 2,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return InkWell(
                              child: CachedNetworkImage(
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.wallpaper),
                                imageUrl: post.postUrl,
                              ),
                              onTap: () {
                                GoRouter.of(context).push("/single-post-screen",
                                    extra: post.postId);
                              },
                            );
                          },
                        )
                      : Text("No post uploaded");
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, st) => Text("Error loading feed: $e"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
