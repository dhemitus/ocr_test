import 'dart:convert';
import 'package:equatable/equatable.dart';

class Rect extends Equatable {
  final double w, x, h, y;

  const Rect({
    required this.w,
    required this.x,
    required this.h,
    required this.y
  });


  Rect copyWith({
    double? w,
    double? x,
    double? h,
    double? y
  }) => Rect(
    w: w ?? this.w,
    x: x ?? this.x,
    h: h ?? this.h,
    y: y ?? this.y
  );

  Map<String, dynamic> toMap() => {
    'w': w,
    'x': x,
    'h': h,
    'y': y
  };

  String toJson() => json.encode(toMap());

  factory Rect.fromMap(Map<String, dynamic> _map) => Rect(
    w: _map['w'] ?? 0.0,
    x: _map['x'] ?? 0.0,
    h: _map['h'] ?? 0.0,
    y: _map['y'] ?? 0.0,
  );

  factory Rect.fromJson(String _json) => Rect.fromMap(json.decode(_json));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [w, x, h, y];
}
