// A widget that displays the picture taken by the user.
import 'dart:io';

import 'package:ateam_accounting_12/API/DataBaseConn.dart';
import 'package:ateam_accounting_12/Models/CameraProv.dart';
import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() {
    return _DisplayPictureScreenState();
  }
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  var imagePath;
  var message = "";
  bool? isPortrait;
  var _containerWidth;
  var _conn = DataBaseConn();

  @override
  Widget build(BuildContext context) {
    print('built');

    imagePath = widget.imagePath;
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    if (_height > _width) {
      isPortrait = true;
      _containerWidth = _width;
    } else {
      isPortrait = false;
      _containerWidth = _height;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        width: _containerWidth,
        height: _height,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(_conn.assetBackgroundImage))),
        child: ListView(
          children: [
            Container(
                //   color: Colors.black,
                width: _containerWidth * 3 / 4,
                height: _height * 3 / 4,
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                )),
            IconButton(
                iconSize: 50,
                color: Colors.deepOrange[50],
                hoverColor: Colors.deepOrange,
                highlightColor: Colors.deepOrange,
                alignment: Alignment.bottomCenter,
                onPressed: () async {

                  await showDialog(context: context, builder: (context){
                    return Consumer<CustomerData>(
                      builder: (context,customerData,_){
                        customerData.uploadImage(customerData.potentialCustomer);
                        return AlertDialog(
                          content: StreamBuilder<String>(stream: customerData.messageStream,
                          builder: (context,snapshot){
                            if (snapshot.hasData){
                              customerData.uploadImageFile=null;
                              return Text(snapshot.data!);
                            }else if(snapshot.hasError){
                              return Text("error in upload file");
                            }else{
                              return Center(child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(),),);
                            }

                          },),
                        );
                      },
                    );
                  });
                  Provider.of<CustomerData>(context, listen: false)
                      .uploadImageFile =File(imagePath);

                  Provider.of<CameraProv>(context, listen: false).picChosen =
                      true;

                  Navigator.of(context).pop();


                  //    Navigator.popUntil(
                  //        context, ModalRoute.withName('/AddNewUserForm'));
                },
                icon: Icon(Icons.upload))
          ],
        ),
      ),
    );
  }
}
