import 'package:ateam_accounting_12/Models/CameraProv.dart';
import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:ateam_accounting_12/Widgets/InstructorDropdownWidget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CameraWidget.dart';

class AddNewUserForm extends StatefulWidget {
  @override
  State<AddNewUserForm> createState() {
    return _AddNewUSerFormState();
  }
}

class _AddNewUSerFormState extends State<AddNewUserForm> {
  final _formKey = GlobalKey<FormState>();

  var selectedIndex = 0;

  var showColumn = false;
  double _topsize = 0;
  double _coverHeight = 0;
  double _profileHeight = 0;
  double _radius = 0;
  late Future<CameraDescription> firstCamera;

  bool _nullImage = true;

  String _message = "";

  @override
  void initState() {
    super.initState();
    Provider.of<CustomerData>(context, listen: false).uploadImageFile=null;
    Provider.of<CameraProv>(context, listen: false).picChosen = false;
  }

  @override
  Widget build(BuildContext context) {
    _coverHeight = MediaQuery.of(context).size.height / 4;
    _profileHeight = MediaQuery.of(context).size.height * 3 / 4;
    _radius = _coverHeight / 2;
    _topsize = _coverHeight - _radius;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.jpeg"),
                fit: BoxFit.cover,
                opacity: 0.5)),
        child: Consumer<CustomerData>(
          builder: (context, customerData, _) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          left: 0, right: 0, top: 0, bottom: _radius * 1.2),
                      color: Colors.grey[400],
                      height: _coverHeight,
                      clipBehavior: Clip.none,
                      child: buildTop(context)),
                  Container(
                    height: _profileHeight,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/background.jpeg"),
                          fit: BoxFit.cover,
                          opacity: 0.2),
                    ),
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                          ListTile(
                            leading: const Icon(Icons.arrow_circle_right),
                            title: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'customer name cannot be empty';
                                }
                              },
                              onSaved: (value) {
                                customerData.potentialCustomer.first_name =
                                    value!;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                labelText: "Name",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (value) {
                                  customerData.potentialCustomer.email = value!;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  labelText: "Email",
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (!value!.contains('@')) {
                                    return 'invalid email address';
                                  }
                                }),
                          ),
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: TextFormField(
                              keyboardType: TextInputType.phone,
                              onSaved: (value) {
                                customerData.potentialCustomer.phoneNumber =
                                    value!;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                labelText: " Phone Number",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.location_on_rounded),
                            title: TextFormField(
                              onSaved: (value) {
                                customerData.potentialCustomer.address = value!;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                labelText: "Address",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          ListTile(
                              leading: const Icon(
                                  Icons.sports_martial_arts_outlined),
                              title: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  onSaved: (value) {
                                    customerData.potentialCustomer
                                        .classAttended = value!;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[300],
                                    labelText: "Class",
                                    border: InputBorder.none,
                                  ),
                                ),
                              )),
                          InstructorDropdownWidget(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                    color: Colors.black,
                                    size: 50,
                                    Icons.add_box),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    customerData.addNewCustomer();
                                    showDialog(
                                      builder: (context) {
                                        _message = "";
                                        return AlertDialog(
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('ok'))
                                            ],
                                            content: StreamBuilder<String>(
                                                stream: customerData
                                                    .streamController.stream,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    _message +=
                                                        " ${snapshot.data!}";
                                                    return Text(_message);
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                        'error: ${snapshot.error}');
                                                  } else {
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  }
                                                }));
                                      },
                                      context: context,
                                    );

                                    //  Navigator.of(context).pop();
                                    //customerData.addNewCustomer();
                                  }
                                },
                              )
                            ],
                          )
                        ])),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    //buildTop(context);
  }

  Widget buildTop(BuildContext context) {
    _coverHeight = MediaQuery.of(context).size.height / 4;
    _profileHeight = MediaQuery.of(context).size.height * 3 / 4;
    _radius = _coverHeight / 2;
    _topsize = _coverHeight - _radius;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Container(
                height: _coverHeight,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/default_cover_pic.jpeg"),
                  fit: BoxFit.cover,
                ))),
          ],
        ),
        Positioned(
          top: _topsize,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const CameraWidget();
                    }));
                  });
                },
                child: Consumer<CustomerData>(
                  builder: (context, customerData, _) {
                    if (customerData.uploadImageFile == null) {
                      //    _nullImage = true;
                      //setState(() {});
                      return CircleAvatar(
                        radius: _radius,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: _radius - 10,
                          //   backgroundImage: null,
                          backgroundImage:
                              AssetImage("assets/images/profilePic.png"),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(child: const Icon(Icons.add)),
                          ),
                        ),
                      );
                    } else {
                      return CircleAvatar(
                          radius: _radius,
                          //  child: Icon(Icons.add),
                          foregroundImage:
                              FileImage(customerData.uploadImageFile!),
                          backgroundImage:
                              AssetImage("assets/images/profilePic.png"));
                    }
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
