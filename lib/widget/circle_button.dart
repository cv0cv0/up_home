import 'package:flutter/material.dart';

class CircleButtonWithText extends CircleButton {
  CircleButtonWithText({this.text, this.color, this.onTap})
      : super(
          color: color,
          onTap: onTap,
          child: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15.0)),
        );

  final String text;
  final Color color;
  final VoidCallback onTap;
}

class CircleButtonWithIcon extends CircleButton {
  CircleButtonWithIcon({this.icon, this.color, this.onTap})
      : super(
          color: color,
          onTap: onTap,
          child: Image.asset(icon, width: 36.0, height: 36.0),
        );

  final String icon;
  final Color color;
  final VoidCallback onTap;
}

class CircleButton extends StatelessWidget {
  const CircleButton({Key key, this.color, this.child, this.onTap})
      : super(key: key);

  final Color color;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60.0,
          height: 60.0,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: child,
        ),
      );
}
