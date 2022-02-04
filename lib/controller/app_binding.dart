import 'package:get/get.dart';
import 'package:police/controller/controller.dart';

class AppBinding implements Bindings {

  @override
  void dependencies() {
    Get.put<CaptureController>(CaptureController(), permanent: true);
    Get.put<DetectionController>(DetectionController(), permanent: true);
  }
}
