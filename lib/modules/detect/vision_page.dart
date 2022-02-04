import 'dart:io';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:police/controller/controller.dart';
import 'package:police/data/data.dart';
import 'package:police/modules/modules.dart';

class VisionPage extends StatefulWidget {
  final List<CameraDescription>? camera;

  const VisionPage(this.camera);

  @override
  _VisionPageState createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> with WidgetsBindingObserver {
  late CameraController _controller;
  late bool _play;
  late CameraDescription _camera;
  late DetectionController _detect;
  //final ImageConverter imageConverter = ImageConverter();

  @override
  initState() {
    _play = false;
    super.initState();
    _camera = widget.camera![0];
    print(_camera.sensorOrientation);
    print(InputImageRotationMethods.fromRawValue(_camera.sensorOrientation));
    _controller = CameraController(_camera, ResolutionPreset.medium, enableAudio: false, imageFormatGroup: ImageFormatGroup.yuv420);
    _cameraInit();
    _detect = Get.find<DetectionController>();
  }

  @override
  dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future _cameraInit() async {
    await _controller.initialize();
    setState(() {});
  }

  List<Widget> _list(List<InferenceResult> ln) {
    List<Widget> _l = <Widget>[];
    if(ln.isNotEmpty) {
      ln.map((InferenceResult _in) {
        _l.add(
          Positioned(
            top: _in.rect.x * _detect.imageSize.value.width,
            left: _in.rect.y * _detect.imageSize.value.height,
            width: _in.rect.w * _detect.imageSize.value.width,
            height: _in.rect.y * _detect.imageSize.value.height,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color: Colors.pink, width: 1.0)
              )
            )
          )
        );
      }).toList();

    } else {
      _l.add(Container());
    }
    return _l;
  }

  Widget _boxes() {
    return Obx(() {
      print('detection result ===============');
      print(_detect.result.value.length);
      print('detection result ===============');
      if(_detect.result.value.isNotEmpty) {
        return Center(
          child: Text('adaaaaaaa ${_detect.result.value.length}')
        );
      } else {
        return Container();
      }
      /*return Stack(
        children: _list(_detect.result.value)
      );*/
    });
  }

  _start() {
    print('start');
    _controller.startImageStream((CameraImage image) {
      //Image _preview = imageConverter.yuv420ToBGR(image);
      if(_detect.isTFReady) {
        _detect.find(image);
      }
      /*print('width: ' + image.width.toDouble().toString());
      print('height: ' + image.height.toDouble().toString());
      print(image.format.raw);
      print(InputImageFormatMethods.fromRawValue(image.format.raw));
      print(image.planes.length);*/
    });
    _play = true;
  }

  Future _stop() async {
    print('stop');
    await _controller.stopImageStream();
    _play = false;
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    print(_size.width);
    print(_size.height);
    if(widget.camera!.isEmpty) return Container();

    if(!_controller.value.isInitialized) return Container();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          CameraPage(_camera, _controller),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              child: (_play) ? const Text('stop') : const Text('scan...'),
              onPressed: () {
                (_play) ? _stop() : _start();
              },
            )
          ),
          Obx(() => BoundingPage(
            _detect.result.value,
            math.max(720, 480),
            math.min(720, 480),
            _size.height,
            _size.width
          )),
        ]
      )
    );
    /*return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Material (
        color: Colors.white,
        child: Stack(
          children: <Widget> [
            CameraPreview(_controller),
            _boxes(),

            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                child: (_play) ? const Text('stop') : const Text('scan...'),
                onPressed: () {
                  (_play) ? _stop() : _start();
                },
              )
            )
          ]
        )
      )
    );*/
  }
}
