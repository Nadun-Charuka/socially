import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/providers/feed_provider.dart';
import 'package:socially/providers/user_provider.dart';
import 'package:socially/services/auth/auth_services.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:socially/widgets/reuseable/custom_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _SingleUserScreenState();
}

class _SingleUserScreenState extends ConsumerState<ProfileScreen> {
  final User _currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final appUserAsync = ref.watch(appUserProvider);
    final feedAsync = ref.watch(feedByIdProvider(_currentUser.uid));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: appUserAsync.when(
            data: (user) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          width: 80,
                          height: 80,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.person),
                          imageUrl: user!.photoUrl,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${user.followers} Followers",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Text(
                                "${user.following} Followings",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(user.email),
                      IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: mainOrangeColor,
                        ),
                        onPressed: () async {
                          await AuthService().logout();
                        },
                      ),
                    ],
                  ),
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
                                crossAxisSpacing: 10,
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
                                    GoRouter.of(context).push(
                                        "/single-post-screen",
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
              );
            },
            error: (e, st) => Text("Error loading user: $e"),
            loading: () => const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
