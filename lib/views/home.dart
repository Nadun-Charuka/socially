import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUserAsyncValue = ref.watch(appUserProvider);

    final authService = ref.read(authServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Socially!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
            },
          ),
        ],
      ),
      body: Center(
        child: appUserAsyncValue.when(
          data: (appUser) {
            if (appUser == null) {
              return const Text('User data not found.');
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: appUser.photoUrl.isEmpty
                          ? 'https://i.stack.imgur.com/l60Hf.png'
                          : appUser.photoUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
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
                  'This is your home screen!',
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                const Text(
                  'More features coming soon...',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
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
