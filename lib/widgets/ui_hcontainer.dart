import 'package:flutter/material.dart';

class UiHContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double border;
  const UiHContainer({
    Key? key,
    required this.child,
    this.color = const Color(0xff0c4641),
    this.border = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: const Color.fromARGB(255, 1, 19, 17),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 15,
            ),
            child: child,
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          child: Container(
            width: border,
            color: color,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: 15,
            height: border,
            color: color,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: 15,
            height: border,
            color: color,
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: Container(
            width: border,
            color: color,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 15,
            height: border,
            color: color,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 15,
            height: border,
            color: color,
          ),
        ),
      ],
    );
  }
}
