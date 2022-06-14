import 'package:flutter/material.dart';

/// BottomBar class contains the buttons to return back to home page
class BottomBar extends StatelessWidget {
  final List<Widget>? children;
  final List<Widget>? rowChildren;
  final Color? barColor;

  // constructor
  const BottomBar({Key? key, this.children, this.rowChildren, this.barColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/splash_background.png"),
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            // stack children
            ...children!,

            // row children
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    color: barColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [...rowChildren!],
                    )))
          ],
        ));
  }
}
