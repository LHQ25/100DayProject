import 'package:flutter/material.dart';

mixin SimpleColor1 {
  static Color color333333 = const Color(0xFF333333);
}

extension on Colors {
  static const Color color333333 = Color(0xFF333333);

  // static Color color333333() => const Color(0xFF333333);
}

void main() async {}

// extension Colors on SimpleColor {}
