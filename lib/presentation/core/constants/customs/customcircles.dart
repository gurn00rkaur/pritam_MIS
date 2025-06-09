import 'package:flutter/material.dart';

class Customcircles extends StatelessWidget {
  const Customcircles({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -10, // Aligns the semicircle to the right edge
          top: -12,
          child: Container(
            height: 68,
            width: 68,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 206, 34, 34),
                shape: BoxShape.circle),
          ),
        ),
        Positioned(
          right: -20, // Aligns the semicircle to the right edge
          top: -20,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white),
                shape: BoxShape.circle),
            height: 86,
            width: 86,
          ),
        ),
        Positioned(
          right: 26,
          top: -24,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 40,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle),
              height: 8,
              width: 8,
            ),
          ),
        ),
        Positioned(
          right: 62,
          // top: 0,
          bottom: 92,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 40,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle),
              height: 5,
              width: 5,
            ),
          ),
        ),
      ],
    );
  }
}
