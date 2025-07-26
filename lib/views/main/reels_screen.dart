import 'package:flutter/material.dart';
import 'package:socially/widgets/main/reels/add_reels_widget.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  void showAddReelModel() {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) => AddReelsWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reels"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddReelModel(),
        child: Icon(Icons.add),
      ),
    );
  }
}
