import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/models/reel_model.dart';
import 'package:socially/services/reels/reels_service.dart';

final reelStreamProvider = StreamProvider<List<ReelModel>>(
  (ref) {
    final reelservice = ReelsService();
    return reelservice.getReelsStream();
  },
);
