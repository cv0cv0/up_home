import 'package:flutter/material.dart';

class RectangleButton extends StatelessWidget {
  const RectangleButton({
    Key key,
    this.text,
    this.width,
    this.height = 48.0,
    this.color,
    this.textColor,
    this.onTap,
  }) : super(key: key);

  final String text;
  final double width;
  final double height;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          color: color,
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(color: textColor, fontSize: 16.0)),
        ),
      );
}
