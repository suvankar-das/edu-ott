import 'package:flutter/material.dart';

class PositionedLogo extends StatelessWidget {
  const PositionedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 5,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
