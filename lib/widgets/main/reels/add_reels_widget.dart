import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/models/reel_model.dart';
import 'package:socially/services/auth/auth_services.dart';
import 'package:socially/services/reels/reels_service.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:socially/utils/functions/common.dart';
import 'package:socially/widgets/reuseable/custom_button.dart';
import 'package:video_player/video_player.dart';

class AddReelsWidget extends StatefulWidget {
  const AddReelsWidget({super.key});

  @override
  State<AddReelsWidget> createState() => _AddReelsWidgetState();
}

class _AddReelsWidgetState extends State<AddReelsWidget> {
  final currentUser = AuthService().currentUser!;
  final ReelsService reelService = ReelsService();
  TextEditingController captionController = TextEditingController();
  VideoPlayerController? _videoPlayerController;
  File? _videoFile;
  bool _isUploading = false;

  //pick video
  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final pickedVideoFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideoFile != null) {
      setState(() {
        _videoFile = File(pickedVideoFile.path);
        _videoPlayerController?.dispose();
        _videoPlayerController = VideoPlayerController.file(_videoFile!)
          ..initialize().then(
            (value) {
              setState(() {});
              _videoPlayerController!.play();
            },
          );
      });
      debugPrint("Video selected : ${_videoFile?.path}");
    }
  }

  //save reel
  Future<void> saveReel() async {
    if (_videoFile != null) {
      setState(() {
        _isUploading = true;
      });

      if (kIsWeb) {
        return;
      }
      final imgUrl = await reelService.uploadVideo(
          videoFile: _videoFile!, userId: currentUser.uid);

      final reelId = FirebaseFirestore.instance.collection('reels').doc().id;
      final newReel = ReelModel(
        caption: captionController.text.trim(),
        videoUrl: imgUrl,
        userId: currentUser.uid,
        reelId: reelId,
        datePublished: DateTime.now(),
        userName: currentUser.displayName!,
        userProfileImg: currentUser.photoURL!,
      );
      debugPrint("new reel created");
      reelService.saveReel(newReel);
      setState(() {
        _isUploading = false;
      });
      if (mounted) Navigator.of(context).pop();
      debugPrint("new reel uploaded sucessfully");
      if (mounted) showSnackBar(text: "Reels Uploaded", context: context);
    } else {
      Navigator.of(context).pop();

      showSnackBar(
          text: "Upload a Video file to post a reel", context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 15,
          children: [
            TextField(
              controller: captionController,
              decoration: InputDecoration(
                hintText: "caption",
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainOrangeColor),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            (_videoFile != null &&
                    _videoPlayerController != null &&
                    _videoPlayerController!.value.isInitialized)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                  )
                : const Text("No video selected"),
            CustomButton(
              text: "Select Video",
              width: double.infinity,
              onPressed: () {
                pickVideo();
              },
            ),
            CustomButton(
              text: _isUploading ? "Wait Uploading..." : "Post",
              width: double.infinity,
              onPressed: () async {
                await saveReel();
                debugPrint("id : ${currentUser.uid}");
                debugPrint("id : ${currentUser.photoURL}");
                debugPrint("name : ${currentUser.displayName}");
              },
            ),
          ],
        ),
      ),
    );
  }
}
