import 'package:flutter/material.dart';

/// MyIconButton is a custom icon button widget
class MyIconButton extends StatelessWidget {
    
  // field related to icon (size and the actual icon)
  final double? iconSize;
  final Icon? icon;

  // function that handels onPressed
  final VoidCallback? action;

  // constructor
  const MyIconButton({Key? key, this.iconSize, this.icon, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: iconSize!,
      icon: icon!,
      onPressed: action,
    );
  }
}
