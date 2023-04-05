// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:ateam_accounting_12/API/DataBaseConn.dart';
import 'package:ateam_accounting_12/Models/CameraProv.dart';
import 'package:ateam_accounting_12/Widgets/DisplayPictureScreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? _controller;

  void initState() {
    super.initState();
    //  Provider.of<CameraProv>(context, listen: false).setCameraAndController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    // Provider.of<CameraProv>(context, listen: false).disposeController();
    super.dispose();
  }

  var _conn = DataBaseConn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(_conn.assetBackgroundImage))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(clipBehavior: Clip.none, children: [
            FutureBuilder(
                future:
                    Provider.of<CameraProv>(context, listen: false).setCamera(),
                builder: (context, snapData) {
                  if (snapData.hasData) {
                    return CameraPreview(snapData.data!);
                  } else if (snapData.hasError) {
                    return Text('Camera did not set properly');
                  } else {
                    return Column(
                      children: [
                        Text('waiting on the world to change...'),
                        CircularProgressIndicator()
                      ],
                    );
                  }
                }),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                color: Colors.white10,
                child: IconButton(
                  focusColor: Colors.deepOrange,
                  hoverColor: Colors.deepOrange,
                  color: Colors.deepOrange[100],
                  iconSize: 50,
                  icon: Icon(Icons.swap_horiz),
                  onPressed: () {
                    Provider.of<CameraProv>(context, listen: false)
                        .flipCamera();
                    //  Provider.of<CameraProv>(context, listen: false).setCamera();
                    setState(() {});
                  },
                ),
              ),
              Consumer<CameraProv>(builder: (context, cameraData, _) {
                return IconButton(
                  color: Colors.deepOrange,
                  onPressed: () async {
                    try {
                      // await cameraData.initializeControllerFuture;
                      final image = await cameraData.controller.takePicture();
                      if (!mounted) return;

                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                            imagePath: image.path,
                          ),
                        ),
                      );
                      if (cameraData.picChosen) Navigator.of(context).pop();

                      //     Navigator.of(context).pop();
                    } catch (e) {
                      print(e);
                    }
                  },
                  icon: Icon(size: 50, Icons.camera_alt),
                );
              })
            ],
          ),
        ],
      ),
    ));
  }
}
