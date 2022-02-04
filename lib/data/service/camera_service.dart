import 'package:camera/camera.dart';

class CameraService {
  static CameraService get instance => CameraService._();
  late List<CameraDescription> _cameras;
  late CameraController _controller;

  List<CameraDescription> get cameras => _cameras;

  bool get noCamera => _cameras.isEmpty;

  bool get initialized => _controller.value.isInitialized;

  CameraController get cameraController => _controller;

  CameraService._();

  void setController(List<CameraDescription> _cameras) {
    _controller = CameraController(_cameras[0], ResolutionPreset.medium, enableAudio: false, imageFormatGroup: ImageFormatGroup.yuv420);
  }

  Future<void> initialize() async {
    await _controller.initialize();

    _controller.startImageStream(_captureImage);

  }

  _captureImage(CameraImage _image) async {

  }

  void stop() async {
    await _controller.stopImageStream();
  }

  void dispose() {
    _controller.stopImageStream();
    _controller.dispose();
  }
}
