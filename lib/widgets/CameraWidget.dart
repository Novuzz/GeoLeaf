import 'package:camera/camera.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:geo_leaf/screen/ImageScreen.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  List<CameraDescription> cameras = [];
  CameraController? controller;

  @override
  void initState() {
    // TODO: implement initState
    _setup();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _cameraUI();
  }

  Widget _cameraUI() {
    if (controller == null || controller?.value.isInitialized == null) {
      return Center();
    }
    return SizedBox.expand(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.75,
            child: CameraPreview(controller!),
          ),
          IconButton(
            onPressed: () async {
              XFile? file = await controller?.takePicture();
              Image image = Image(image: XFileImage(file!));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageScreen(image: image.image),
                ),
              );
            },
            icon: Icon(size: 64, Icons.camera),
          ),
        ],
      ),
    );
  }

  Future<void> _setup() async {
    List<CameraDescription> _cameras = await availableCameras();
    setState(() {
      cameras = _cameras;
      controller = CameraController(cameras.first, ResolutionPreset.high);
    });
    controller?.initialize().then((_) {
      setState(() {});
    });
  }
}
