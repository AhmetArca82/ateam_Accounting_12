import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class CameraProv extends ChangeNotifier {
  bool front = true;

  late CameraDescription camera;
  bool picChosen = false;
  late CameraController controller;

  Future<CameraController> setCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    camera = front ? cameras.last : cameras.first;
    controller = CameraController(camera, ResolutionPreset.medium);
    var initializeControllerFuture = controller.initialize();
    await initializeControllerFuture;

    return controller;
  }

  void disposeController() {
    controller.dispose();
  }

  Future<void> flipCamera() async {
    front = !front;
  }
}
