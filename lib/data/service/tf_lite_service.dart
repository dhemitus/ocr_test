import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imlib;
import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';
import 'package:police/data/data.dart';

class TfLiteService {
  final String model = 'assets/model/alpr.tflite';
  final String label = 'assets/model/alpr.txt';
  bool _isReady = false;
  late int imageResizeTime;
  late int imageByteTime;
  late int imageInferenceTime;
  late Size imageSize;
  bool _isSize = false;

  TfLiteService._() {
    _isReady = false;
    _isSize = false;
  }

  static TfLiteService get instance => TfLiteService._();

  bool get isReady => _isReady;

  Future<void> initialize() async {
    try {
      await Tflite.loadModel(
        model: model,
        labels: label,
        numThreads: 2,
        isAsset: true,
        useGpuDelegate: false
      );
      _isReady = true;
    } catch(e) {
      print(e);
    }
  }

  Future<void> close() async {
    try {
      await Tflite.close();
      _isReady = false;
    } catch (e) {
      print(e);
    }
  }

  Future<void> reset() async {
    try {
      await close();
      await initialize();
    } catch(e) {
      print(e);
    }
  }

  _setSize(CameraImage image) {
    if(!_isSize) {
      imageSize = Size(image.width.toDouble(), image.height.toDouble());
      _isSize = true;
    }
  }


  Future<List<InferenceResult>?> inferenceFrame(CameraImage image) async {
    List<dynamic>? _result;
    List<InferenceResult>? _inferences;
    Stopwatch _st = Stopwatch();
    _st.start();

    _setSize(image);
    try {
      if(_isReady) {
        print('detection is $_isReady');
        print(image.height);
        print(image.width);
        _result = await Tflite.detectObjectOnFrame(
          bytesList: image.planes.map((Plane plane) => plane.bytes).toList(),
          imageHeight: image.height,
          imageWidth: image.width,
          model: 'SSDMobileNet',
          imageMean: 172.5,
          imageStd: 172.5,
          threshold: 0.04,
          numResultsPerClass: 1,
          asynch: true
        );
        print(_result);
        print('result okeeeee');
      }
      imageInferenceTime = _st.elapsedMilliseconds;
    } catch(e) {
      reset();
    }
    _st.stop();
    if(_result != null) {
      _inferences = _result.map((e) => InferenceResult.fromMap(Map<String, dynamic>.from(e))).toList();
    }
    return _inferences;
  }
/*
  Future<List<dynamic>?> inferenceImage(Image image) async {
    List<dynamic>? _result;
    Stopwatch _st = Stopwatch();
    _st.start();
    var reseizeImage = copyResize(image, width:320, height: 320);
    imageResizeTime = _st.elapsedMilliseconds;
    _st.reset();
    var imageDatax = reseizeImage.getBytes(format: Format.rgb).buffer.asUint8List();
    var imageData = imageToByteListFloat32(reseizeImage, 320, 0, 255);
    imageByteTime = _st.elapsedMilliseconds;
    _st.reset();

    try {
      _result = await Tflite.detectObjectOnBinary(binary: imageData, model: 'SSDMobileNet', threshold: 0.5, numResultsPerClass: 5, asynch: true);
      imageInferenceTime = _st.elapsedMilliseconds;
    } catch(e) {
      print(e);
      reset();
    }
    _st.stop();
    return _result;
  }*/
/*
  Uint8List imageToByteListFloat32(
    Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  Uint8List imageToByteListUint8(Image image, int inputSize) {
    var convertedBytes = Uint8List(1 * inputSize * inputSize * 3);
    var buffer = Uint8List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = getRed(pixel);
        buffer[pixelIndex++] = getGreen(pixel);
        buffer[pixelIndex++] = getBlue(pixel);
      }
    }
    return convertedBytes.buffer.asUint8List();
  }*/
}
