import 'package:flutter/material.dart';

class UiArea extends StatelessWidget {
  final Widget child;
  final Color color;
  const UiArea({
    Key? key,
    required this.child,
    this.color = const Color(0xff0c4641),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 15,
        ),
        child: child,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 1, 19, 17),
        border: Border.all(
          color: color,
          width: 1.2,
        ),
      ),
    );
  }
}
