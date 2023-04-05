
import 'package:ateam_accounting_12/API/DataBaseConn.dart';
import 'package:ateam_accounting_12/Models/CameraProv.dart';
import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:ateam_accounting_12/Widgets/CameraWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildAvatar extends StatefulWidget {
  const BuildAvatar({super.key});

  @override
  State<BuildAvatar> createState() {
    return _BuildAvatarState();
  }
}

class _BuildAvatarState extends State<BuildAvatar> {
  double boxHeight=0;
   double boxWidth=0;
  double avatarRadius = 100.0;
  final _conn = DataBaseConn();

  @override
  Widget build(BuildContext context) {
    boxHeight = MediaQuery.of(context).size.height / 5;
    boxWidth = MediaQuery.of(context).size.width;
    avatarRadius = boxHeight / 2;
    Provider.of<CustomerData>(context, listen: false).generateLink(
        Provider.of<CustomerData>(context, listen: false).potentialCustomer);
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5,
      //width: MediaQuery.of(context).size.height / 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer2<CustomerData, CameraProv>(
          builder: (context, customerData, camera, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(children: [
                  SizedBox(
                    height: boxHeight,
                    width: boxHeight,
                    child: ClipOval(
                      child: Builder(
                        builder: (context) {

                            return (customerData.uploadImageFile != null)
                                ? Container(
                                    child: Image.file(
                                    customerData.uploadImageFile!,
                                    fit: BoxFit.cover,
                                  ))
                                : Image.network(
                              customerData.potentialCustomer.picLink,
                              fit: BoxFit.cover,
                              errorBuilder: (context, obect, snapshot) {
                                return Image.asset(_conn.assetProfileImage);
                              },
                            );

                        },
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      //   left: avatarRadius,
                      child: SizedBox(
                          width: avatarRadius / 2,
                          height: avatarRadius / 2,
                          child: FittedBox(
                              child: FloatingActionButton(heroTag: null,

                                                            backgroundColor: Colors.brown[100],
                            elevation: 2,
                            //  iconSize: avatarRadius / 5,
                            onPressed: () {
                              print('object');
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const CameraWidget();
                              }));
                            },
                            child: const Icon(Icons.edit),
                          )))),
                ]),
                /*   CircleAvatar(
                  backgroundColor: Colors.black12,
                  foregroundColor: Colors.black,
                  foregroundImage: toDisplay,
                  backgroundImage: AssetImage('assets/images/profilePic.png'),
                  //  radius: 100,
                  radius: avatarRadius,
                  child: Stack(
                      alignment: Alignment.centerLeft,
                      clipBehavior: Clip.none,
                      children: [
                        Align(
                            alignment: Alignment.bottomRight,
                            //   left: avatarRadius,
                            child: SizedBox(
                                width: avatarRadius / 2,
                                child: FittedBox(
                                    child: FloatingActionButton(
                                      elevation: 2,
                                      //  iconSize: avatarRadius / 5,
                                      onPressed: () {
                                        print('object');
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) {
                                              return const CameraWidget();
                                            }));
                                      },
                                      child: Icon(Icons.edit),
                                    )))),
                        toDisplay,
                      ]),
                ),*/
                buildActiveID(customerData),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildActiveID(
    CustomerData customerData,
  ) {
    final myCust = customerData.selectedCustomer;
    Widget myRow = Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ID : ${myCust.customer_id}',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
          (myCust.active == 'false')
              ? const Text('inactive',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold))
              : Text('active',
                  style: TextStyle(
                      color: Colors.green[50],
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
        ],
      ),
    );
    return myRow;
  }
}
