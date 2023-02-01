import 'package:flutter/material.dart';
import 'dart:ui' as ui show Gradient;

class UnderlineGradientTabIndicator extends Decoration {
  const UnderlineGradientTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
  });

  final BorderSide borderSide;
  final EdgeInsetsGeometry insets;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlineGradientTabIndicator(this, onChanged);
  }

// Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
//   final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
//   return Rect.fromLTWH(
//     indicator.left,
//     indicator.bottom - borderSide.width,
//     indicator.width,
//     borderSide.width,
//   );
// }
}

class _UnderlineGradientTabIndicator extends BoxPainter {
  _UnderlineGradientTabIndicator(this.decoration, super.onChanged);

  final UnderlineGradientTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    // final TextDirection textDirection = configuration.textDirection!;
    // final Rect indicator = decoration
    //     ._indicatorRectFor(rect, textDirection)
    //     .deflate(decoration.borderSide.width / 2.0);
    Paint paint = decoration.borderSide.toPaint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(const Offset(0, 0), Offset(rect.right.toDouble(), rect.bottom.toDouble()),
          [const Color(0xFFF72800), const Color(0xFFF72800).withOpacity(0.1)]);
    canvas.drawRect(Rect.fromLTRB(rect.left, rect.bottom - 10, rect.right, rect.bottom - 8), paint);
    // canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
