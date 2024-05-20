// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  final VoidCallback onPressed;
  const RoundedButton({
    Key? key,
    required this.name,
    required this.height,
    required this.width,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height * 0.25),
        color: const Color.fromRGBO(0, 82, 218, 1.0),
      ),
      height: height,
      width: width,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.white,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
