import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:police/data/data.dart';

class InferenceResult extends Equatable {
  final Rect rect;
  final double confidenceInClass;
  final String detectedClass;

  const InferenceResult({
    required this.rect,
    required this.confidenceInClass,
    required this.detectedClass
  });

  InferenceResult copyWith({
    Rect? rect,
    double? confidenceInClass,
    String? detectedClass
  }) => InferenceResult(
    rect: rect ?? this.rect,
    confidenceInClass: confidenceInClass ?? this.confidenceInClass,
    detectedClass: detectedClass ?? this.detectedClass
  );

  Map<String, dynamic> toMap() => {
    'rect': rect.toMap(),
    'confidenceInClass': confidenceInClass,
    'detectedClass': detectedClass
  };

  String toJson() => json.encode(toMap());

  factory InferenceResult.fromMap(Map<String, dynamic> _map) => InferenceResult(
    rect: _map['rect'] != null ? Rect.fromMap(Map<String, dynamic>.from(_map['rect'])) : const  Rect(x: 0, y: 0, w: 0, h: 0),
    confidenceInClass: _map['confidenceInClass'] ?? 0.0,
    detectedClass: _map['detectedClass'] ?? ''
  );

  factory InferenceResult.fromJson(String _json) => InferenceResult.fromMap(json.decode(_json));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [rect, confidenceInClass, detectedClass];
}
