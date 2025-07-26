import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/providers/auth_provider.dart';
import 'package:socially/utils/constants/colors.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUserAsyncValue = ref.watch(appUserProvider);

    final authService = ref.read(authServiceProvider);

    return Scaffold(
      body: Center(
        child: appUserAsyncValue.when(
          data: (appUser) {
            if (appUser == null) {
              return const Text('User data not found.');
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    width: 120,
                    height: 120,
                    imageUrl: appUser.photoUrl,
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 70,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Hello, ${appUser.name}!',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Email: ${appUser.email}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Followers: ${appUser.followers} | Following: ${appUser.following}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                const Text(
                  'This is your Profile',
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                const Text(
                  'More features coming soon...',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Log out"),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: mainOrangeColor,
                      ),
                      onPressed: () async {
                        await authService.logout();
                      },
                    ),
                  ],
                )
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error loading user data: $err'),
        ),
      ),
    );
  }
}
