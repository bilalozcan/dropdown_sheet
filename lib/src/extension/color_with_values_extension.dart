// ignore_for_file: deprecated_member_use

import 'dart:ui';

extension ColorWithValuesExtension on Color {
  Color withValues({double? alpha, int? red, int? green, int? blue}) {
    return Color.fromARGB(
      alpha != null ? (alpha * 255).toInt() : this.alpha,
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
    );
  }
} 