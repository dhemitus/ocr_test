import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:police/data/data.dart';

class BoundingPage extends StatelessWidget {
  final List<InferenceResult> results;
  final int previewH, previewW;
  final double screenH, screenW;

  BoundingPage(this.results, this.previewH, this.previewW, this.screenH, this.screenW);

  @override
  Widget build(BuildContext context) {

    List<Widget> _boxes() {
      List<Widget> _list = [];

      results.map((InferenceResult inf) {
        var _x = inf.rect.x;
        var _y = inf.rect.y;
        var _h = inf.rect.h;
        var _w = inf.rect.w;
        var scaleW, scaleH, x, y, w, h;

        if(screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;

          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if(_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
        }else{
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;

          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if(_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
        }

        _list.add(
          Positioned(
            left: math.max(0, x),
            top: math.max(0, y),
            width: w,
            height: h,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pink, width: 3.0)
              ),
              child: Text(
                '${inf.detectedClass} ${(inf.confidenceInClass * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink
                )
              )
            )
          )
        );

      }).toList();

      return _list;
    }

    return Stack(
      children: _boxes()
    );
  }
}
