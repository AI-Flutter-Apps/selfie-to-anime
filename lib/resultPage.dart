import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

// custom components
import 'package:selfie2anime/bottombar.dart';
import 'package:selfie2anime/gradientcolor.dart';
import 'package:selfie2anime/iconbutton.dart';
import 'package:selfie2anime/mybutton.dart';

class ResultPage extends StatefulWidget {
  // captured/uploaded image and bar color
  final XFile? image;
  final Color? barColor;

  // constructor
  const ResultPage({Key? key, this.image, this.barColor}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPage();
}

/// ResultPage displays the captured/uploaded image for Resultation
class _ResultPage extends State<ResultPage> {
  // capture icon
  final Icon outercircle = const Icon(
    Icons.circle,
    size: 100,
    color: Colors.white,
  );
  final Icon innercircle = const Icon(
    Icons.camera,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pass barColor, rowChildren, stackChildren
      body: BottomBar(
        // bottom bar color
        barColor: widget.barColor,

        // widgets inside the bar
        rowChildren: [
          Stack(children: [
            // move icons up to hang from the bar
            Transform.translate(
              offset: const Offset(0, -40),
              child: LinearGradientMask(child: outercircle),
            ),
            Transform.translate(
                offset: const Offset(22, -18),
                child: MyIconButton(
                  iconSize: 40,
                  icon: innercircle,
                  action: () => Navigator.pop(context),
                )),
          ])
        ],
        children: [
          // display image
          Transform.scale(
              scale: 0.7,
              child: Center(child: Image.file(File(widget.image!.path)))),
        ],
      ),
    );
  }
}
