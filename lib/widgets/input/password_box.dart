import 'package:flutter/material.dart';

class PasswordBox extends StatefulWidget {
  final Function(String)? onChanged;

  final String? text;

  const PasswordBox({super.key, this.onChanged, this.text});

  @override
  State<PasswordBox> createState() => _PasswordBoxState();
}

class _PasswordBoxState extends State<PasswordBox> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          onChanged: widget.onChanged,
          obscureText: hidePassword,
          decoration: InputDecoration(labelText: widget.text),
        ),
        Expanded(
          child: Align(
            alignment: AlignmentGeometry.bottomRight,
            child: IconButton(
              onPressed: () => setState(() {
                hidePassword = !hidePassword;
              }),
              icon: Icon(
                hidePassword
                    ? Icons.remove_red_eye_rounded
                    : Icons.remove_red_eye_outlined,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
