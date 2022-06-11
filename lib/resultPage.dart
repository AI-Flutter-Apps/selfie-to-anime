import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

// custom components
import 'package:selfie2anime/bottombar.dart';
import 'package:selfie2anime/gradientcolor.dart';
import 'package:selfie2anime/iconbutton.dart';

/// ResultsPage displays the captured/uploaded image for confirmation
class ResultsPage extends StatelessWidget {

  // captured/uploaded image and bar color
  final XFile? image;
  final Color? barColor;

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
  
  // display result image


  // constructor
  const ResultsPage({Key? key, this.image, this.barColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // Pass barColor, rowChildren, stackChildren
      body: BottomBar(

        // bottom bar color
        barColor: barColor,

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
                )),
          ])
        ],

        children: [
            // captured/uploaded image
            Image.file(File(image!.path), fit: BoxFit.fill),

            // confirm button
        ],
      ),
    );
  }
}
