import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.key,
    this.onSaved,
    this.validator,
    this.decoration,
  });

  final Key key;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final InputDecoration decoration;

  @override
  State<StatefulWidget> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) => TextFormField(
        key: widget.key,
        obscureText: _obscureText,
        validator: widget.validator,
        onSaved: widget.onSaved,
        decoration: widget.decoration.copyWith(
          suffixIcon: GestureDetector(
            onTap: () => setState(() {
                  _obscureText = !_obscureText;
                }),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0,right:8.0),
              child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            ),
          ),
        ),
      );
}
