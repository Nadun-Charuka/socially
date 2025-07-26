import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:socially/widgets/reuseable/custom_button.dart';

class AddReelsWidget extends StatefulWidget {
  const AddReelsWidget({super.key});

  @override
  State<AddReelsWidget> createState() => _AddReelsWidgetState();
}

class _AddReelsWidgetState extends State<AddReelsWidget> {
  TextEditingController captionController = TextEditingController();
  File? _videoFile;
  bool _isUploading = false;

  //pick video
  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final pickedVideoFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideoFile != null) {
      setState(() {
        _videoFile = File(pickedVideoFile.path);
      });
      debugPrint("Video selected : ${_videoFile?.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
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
            _videoFile != null
                ? Text("video source: ${_videoFile!.path}")
                : Text("No Video selected"),
            CustomButton(
              text: "Select Video",
              width: double.infinity,
              onPressed: () {
                pickVideo();
              },
            ),
            CustomButton(
              text: "Post",
              width: double.infinity,
              onPressed: () {
                //todo post vide
              },
            )
          ],
        ),
      ),
    );
  }
}
