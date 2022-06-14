import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final bool opac;
  final Gradient gradient;
  final Gradient gradientopec;
  final VoidCallback? onPressed;
  final Widget child;

  // app theme
  static const Color color1 = Color.fromARGB(255, 122, 231, 238);
  static const Color color2 = Color.fromARGB(255, 210, 114, 178);

  static const Color color1opac = Color.fromARGB(120, 122, 231, 238);
  static const Color color2opac = Color.fromARGB(120, 210, 114, 178);

  const MyElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.opac = false,
    this.gradient = const LinearGradient(colors: [color1, color2]),
    this.gradientopec = const LinearGradient(colors: [color1opac, color2opac]),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: opac ? gradientopec : gradient,
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: child,
      ),
    );
  }
}
