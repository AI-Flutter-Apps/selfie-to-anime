import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// custom components
import 'package:selfie2anime/bottombar.dart';
import 'package:selfie2anime/gradientcolor.dart';
import 'package:selfie2anime/iconbutton.dart';
import 'package:selfie2anime/mybutton.dart';
import 'package:selfie2anime/resultpage.dart';

class ConfirmPage extends StatefulWidget {
  // captured/uploaded image and bar color
  final XFile? image;
  final Color? barColor;

  // constructor
  const ConfirmPage({Key? key, this.image, this.barColor}) : super(key: key);

  @override
  State<ConfirmPage> createState() => _ConfirmPage();
}

/// ConfirmPage displays the captured/uploaded image for confirmation
class _ConfirmPage extends State<ConfirmPage> {

  final platform = const MethodChannel("selfie.anime");

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

  // loading indicator
  static bool _isLoading = false;

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
          Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(50, 50, 50, 250),
              child: Image.file(
                File(widget.image!.path),
                fit: BoxFit.cover,
              )),

          // confirm button
          Stack(children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 200),
                    child: Stack(children: [
                      _isLoading
                          ? Stack(children: [
                              MyElevatedButton(
                                width: 300,
                                height: 300,
                                opac: true,
                                onPressed: () => _startLoading(context),
                                borderRadius: BorderRadius.circular(30),
                                child: TextButton.icon(
                                  icon: const CircularProgressIndicator(
                                      color: Colors.white),
                                  label: const Text('loading ...'),
                                  onPressed: () => {},
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    shadowColor: Colors.white,
                                  ),
                                ),
                              ),
                            ])
                          : MyElevatedButton(
                              width: double.infinity,
                              onPressed: () => _startLoading(context),
                              borderRadius: BorderRadius.circular(30),
                              child: const Text('Animate me!!'),
                            ),
                    ])))
          ])
        ],
      ),
    );
  }

  // This function will be triggered when the button is pressed
  void _startLoading(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    // AI will do its work here
    var resultValue = await platform.invokeMethod("anime", widget.image!.path);

    setState(() {
      _isLoading = false;
    });

    // go to result page
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ResultPage(animeImage: XFile(resultValue), barColor: widget.barColor)),
      );
    }
  }
}
