import 'package:flutter/material.dart';

class CircleText extends StatelessWidget {
  const CircleText({
    this.color = const Color(0xfffb4747),
    this.text,
    this.size,
  });

  final Color color;
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child:
            Text(text, style: TextStyle(color: Colors.white, fontSize: size)),
      );
}
