import 'package:flutter/material.dart';

/// LinearGradientMask adds a linear gradient color to widget based on app theme
class LinearGradientMask extends StatelessWidget {
    
  final Widget? child;

  // app theme
  final Color color1 = const Color.fromARGB(255, 122, 231, 238);
  final Color color2 = const Color.fromARGB(255, 210, 114, 178);

  // constructor
  const LinearGradientMask({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // gradient mask
    return ShaderMask(
      // gradient color
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color1, color2],
        tileMode: TileMode.mirror,
      ).createShader(bounds),

      // child widget
      child: child,
    );
  }
}
