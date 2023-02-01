import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoManagerController extends GetxController {
  late VideoPlayerController playerController;

  @override
  void onInit() {
    super.onInit();
  }

  // void initVideo(String? url) {
  //   if (url != null) {
  //     playerController =
  //         VideoPlayerController.network(formatHint: VideoFormat.dash, videoPlayerOptions: VideoPlayerOptions(), url);
  //   }
  // }

  Future<bool> started(String? url) async {
    if (url?.isEmpty == false) {
      playerController =
          VideoPlayerController.network(formatHint: VideoFormat.dash, videoPlayerOptions: VideoPlayerOptions(), url!);
      await playerController.initialize();
      await playerController.setLooping(true);
      await playerController.play();
    }
    return true;
  }

  @override
  void onClose() {
    playerController.dispose();
    super.onClose();
  }
}
