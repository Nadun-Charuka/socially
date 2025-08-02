import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/services/user/user_services.dart';
import 'package:socially/providers/user_provider.dart';
import 'package:socially/utils/constants/colors.dart';

class FollowButton extends ConsumerStatefulWidget {
  final String currentUserId;
  final String targetUserId;

  const FollowButton({
    super.key,
    required this.currentUserId,
    required this.targetUserId,
  });

  @override
  ConsumerState<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<FollowButton> {
  bool _isProcessing = false;

  void _toggleFollow(bool isFollowing) async {
    setState(() => _isProcessing = true);
    final userService = UserService();

    if (isFollowing) {
      await userService.unfollowUser(
        currentUserId: widget.currentUserId,
        userToUnfollow: widget.targetUserId,
      );
    } else {
      await userService.followUser(
        currentUserId: widget.currentUserId,
        userToFollow: widget.targetUserId,
      );
    }

    setState(() => _isProcessing = false);
    // Optionally show a snackbar or trigger a refresh manually
  }

  @override
  Widget build(BuildContext context) {
    final isFollowingAsync = ref.watch(
      isFollowingProvider((widget.currentUserId, widget.targetUserId)),
    );

    return isFollowingAsync.when(
      data: (isFollowing) {
        return ElevatedButton.icon(
          onPressed: _isProcessing ? null : () => _toggleFollow(isFollowing),
          style: ElevatedButton.styleFrom(
            backgroundColor: isFollowing ? Colors.grey[800] : mainOrangeColor,
          ),
          icon: _isProcessing
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Icon(isFollowing ? Icons.person_remove : Icons.person_add),
          label: Text(
            isFollowing ? "Unfollow" : "Follow",
          ),
        );
      },
      loading: () => const SizedBox(
        width: 80,
        height: 36,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => Text("Error: $e"),
    );
  }
}
