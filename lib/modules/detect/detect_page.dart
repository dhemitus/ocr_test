import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:police/controller/controller.dart';
import 'package:camera/camera.dart';

class DetectPage extends GetView<CaptureController> {
  final List<CameraDescription>? cameras;

  DetectPage({this.cameras});

  void _openCamera() {
    controller.setController(cameras!);
    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {

    _openCamera();
    print(controller.isInitialized);

    if(controller.noCamera.value) return Container();

    if(!controller.isInitialized.value) return Container();

    return Scaffold(

      body: AspectRatio(
        aspectRatio: controller.cameraController.value.aspectRatio,

        child: Material(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              CameraPreview(controller.cameraController)
            ]
          )
        )
      )
    );
  }
}
