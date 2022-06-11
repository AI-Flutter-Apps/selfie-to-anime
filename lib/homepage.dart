import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// custom components
import 'package:selfie2anime/bottombar.dart';
import 'package:selfie2anime/iconbutton.dart';
import 'package:selfie2anime/resultPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _availableCameras;
  Future<void>? _initController;
  var isCameraReady = false;
  XFile? imageFile;
  File? image;

  // App theme color
  final Color barColorOpac = const Color.fromARGB(181, 23, 31, 40);
  final Color barColor = const Color.fromARGB(255, 23, 31, 40);

  /// Icon for capturing photo
  final Icon? photoCapture = const Icon(
    Icons.circle_outlined,
    color: Colors.white,
  );

  /// Icon for uploading photo
  final Icon? photoUpload = const Icon(
    Icons.photo_size_select_actual,
    color: Colors.white,
  );

  /// Icon for flipping camera
  final Icon? photoFlip = const Icon(
    Icons.repeat,
    color: Colors.white,
  );

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getAvailableCameras();
    WidgetsBinding.instance.addObserver(this);
  }

  // get available cameras
  Future<void> _getAvailableCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    _availableCameras = await availableCameras();
    initCamera(_availableCameras!.first);
  }

  Future<void> initCamera(CameraDescription description) async {
    _controller = CameraController(description, ResolutionPreset.high);
    _initController = _controller?.initialize();
    if (!mounted) return;
    setState(() {
      isCameraReady = true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initController = _controller != null
          ? _controller?.initialize()
          : null as Future<void>;
    }
    if (!mounted) return;
    setState(() {
      isCameraReady = true;
    });
  }

  Widget camerWidget(context) {
    var camera = _controller?.value;
    final size = MediaQuery.of(context).size;
    return Transform.scale(
        scale: size.height / size.width,
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Center(child: CameraPreview(_controller!)),
        ));
  }

  void toggleCameraLens() {
    final lensDirection = _controller!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _availableCameras!.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = _availableCameras!.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }
    if (newDescription != null) {
      initCamera(newDescription);
    } else {
      print('Asked camera not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: barColorOpac),
        body: FutureBuilder(
            future: _initController,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return BottomBar(
                  barColor: barColorOpac,
                  rowChildren: [
                    MyIconButton(
                        iconSize: 30,
                        icon: photoUpload,
                        action: () => pickImage(ImageSource.gallery)),
                    MyIconButton(
                        iconSize: 70,
                        icon: photoCapture,
                        action: () => captureImage(context)),
                    MyIconButton(
                        iconSize: 30,
                        icon: photoFlip,
                        action: () => toggleCameraLens()),
                  ],
                  children: [camerWidget(context)],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  captureImage(BuildContext context) {
    _controller!.takePicture().then((file) {
      setState(() {
        imageFile = file;
      });
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultsPage(
                    image: imageFile,
                    barColor: barColor,
                  )),
        );
      }
    });
  }
}