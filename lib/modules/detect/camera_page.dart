import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

class CameraPage extends StatefulWidget {
  final CameraDescription camera;
  final CameraController controller;

  CameraPage(this.camera, this.controller);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
/*  late CameraController _controller;
  bool _isDetect = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium, enableAudio: false, imageFormatGroup: ImageFormatGroup.yuv420);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
/*    if(_controller == null || !_controller.value.isInitialized) {
      return Container();
    }
*/
    Size _tmp = MediaQuery.of(context).size;
    double _scH = math.max(_tmp.height, _tmp.width);
    double _scW = math.min(_tmp.height, _tmp.width);
    _tmp = widget.controller.value.previewSize!;
    double _prevH = math.max(_tmp.height, _tmp.width);
    double _prevW = math.min(_tmp.height, _tmp.width);
    double _scRatio = _scH / _scW;
    double _prevRatio = _prevH / _prevW;

    return OverflowBox(
      maxHeight: _scRatio > _prevRatio ? _scH : _scW / _prevW * _prevH,
      maxWidth: _scRatio > _prevRatio ? _scH / _prevH * _prevW : _scW,
      child: CameraPreview(widget.controller)
    );
  }
}
