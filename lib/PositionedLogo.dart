import 'package:flutter/material.dart';

class PositionedLogo extends StatelessWidget {
  const PositionedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
    );
  }
}
