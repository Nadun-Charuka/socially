import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/providers/reel_provider.dart';
import 'package:socially/widgets/main/reels/add_reels_widget.dart';
import 'package:socially/widgets/main/reels/reel_widget.dart';

class ReelsScreen extends ConsumerStatefulWidget {
  const ReelsScreen({super.key});

  @override
  ConsumerState<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends ConsumerState<ReelsScreen> {
  void showAddReelModel() {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      showDragHandle: true,
      context: context,
      builder: (context) => AddReelsWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reelAsync = ref.watch(reelStreamProvider);
    return Scaffold(
      body: reelAsync.when(
        data: (reels) {
          return reels.isNotEmpty
              ? SingleChildScrollView(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: reels.length,
                    itemBuilder: (context, index) {
                      final reel = reels[index];
                      return ReelWidget(reel: reel);
                    },
                  ),
                )
              : Center(child: Text("No reels"));
        },
        error: (error, stackTrace) => StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return Text("Error in Reels");
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddReelModel(),
        child: Icon(Icons.add),
      ),
    );
  }
}
