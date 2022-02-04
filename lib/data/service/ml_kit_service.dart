import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class MLKitService {
  late int textRecogTime;
  final TextDetector _text = GoogleMlKit.vision.textDetector();

  MLKitService._();

  static MLKitService get instance => MLKitService._();

  Future<String> detectText(Image image, InputImageData data) async {
    try {
      Stopwatch _st = Stopwatch();
      _st.start();
      InputImage _image = InputImage.fromBytes(bytes: Uint8List.fromList(encodeJpg(image)), inputImageData: data);
      RecognisedText _recog = await _text.processImage(_image);
      textRecogTime = _st.elapsedMilliseconds;
      _st.stop();
      return _recog.text;

    } catch (e) {
      rethrow;
    }
  }

  close() {
    _text.close();
  }
}
