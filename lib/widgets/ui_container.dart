import 'package:flutter/material.dart';

class UiContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  const UiContainer({
    Key? key,
    required this.child,
    this.color = const Color(0xff0c4641),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Material(
            color: const Color.fromARGB(255, 1, 19, 17),
            clipBehavior: Clip.antiAlias,
            shape: BeveledRectangleBorder(
              side: BorderSide(
                color: color,
                width: 1.5,
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(
                  20,
                ),
              ),
            ),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 40,
              ),
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                right: 50,
                left: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  child,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          child: Container(
            width: 9,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 1, 19, 17),
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
