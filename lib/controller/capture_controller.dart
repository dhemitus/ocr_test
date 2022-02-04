import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:police/data/data.dart';

class CaptureController extends GetxController {
  final CameraService _capture = CameraService.instance;
  RxBool noCamera = true.obs;
  RxBool isInitialized = true.obs;
  late CameraController cameraController;


  void setController(List<CameraDescription> cameras) {
    _capture.setController(cameras);
  }

  Future<void> initialize() async {
    await _capture.initialize();
    noCamera.value = _capture.noCamera;
    isInitialized.value = _capture.initialized;
    cameraController = _capture.cameraController;
  }

  void stop() {
    _capture.stop();
  }

  @override
  onClose() {
    //_capture.dispose();
    super.onClose();
  }
}
