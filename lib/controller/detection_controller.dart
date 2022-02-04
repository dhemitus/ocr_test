import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:police/data/data.dart';
//import 'package:image/image.dart';

class DetectionController extends GetxController {
  final TfLiteService _tflite = TfLiteService.instance;
  bool isTFReady = false;
  RxList<InferenceResult> result = <InferenceResult>[].obs;
  Rx<Size> imageSize = Size(0, 0).obs;
  bool isSize = false;

  @override
  onInit() {
    super.onInit();
    isTFReady = false;
    isSize = false;
    _tfInitialize();
  }

  Future<void>_tfInitialize() async {
    try {
      _tflite.initialize();
      isTFReady = true;
    } catch(e) {
      print(e);
    }
  }

  _setSize() {
    if(!isSize) {
      imageSize.value = Size(_tflite.imageSize.height, _tflite.imageSize.width);
      print(imageSize.value.width);
      print(imageSize.value.height);
      isSize = true;
    }
  }

  Future<void> find(CameraImage image) async {
    List<InferenceResult>? _result = await _tflite.inferenceFrame(image);
    _setSize();
    if(_result != null) {
      print('result okeeeee===');
      result.value = _result;
      print(result.value);
      print('result okeeeee===');
    }
  }
}
