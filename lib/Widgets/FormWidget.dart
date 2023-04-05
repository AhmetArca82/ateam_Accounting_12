import 'package:ateam_accounting_12/API/DataBaseConn.dart';
import 'package:ateam_accounting_12/Models/CameraProv.dart';
import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:ateam_accounting_12/Models/CustomerRowData.dart';
import 'package:ateam_accounting_12/Models/PaymentData.dart';
import 'package:ateam_accounting_12/Widgets/BuildAvatar.dart';
import 'package:ateam_accounting_12/Widgets/InstructorDropdownWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormWidget extends StatefulWidget {
  FormWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FormWidget> createState() {
    return _FormWidgetState();
  }
}

class _FormWidgetState extends State<FormWidget> {
  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _phoneNumberController = TextEditingController();
  var _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _potentialCustomer = CustomerRowData.emptyForm();
  String _message = "";
  bool _displaySaveButton = false;
  var _conn = DataBaseConn();

  @override
  void initState() {
 //   Provider.of<CustomerData>(context, listen: false).uploadImageFile=null;
    Provider.of<CameraProv>(context, listen: false).picChosen = false;
    Provider.of<CustomerData>(context, listen: false).setSaveButtonsOff();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /*   decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(_conn.assetBackgroundImage))),*/
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          onChanged: () {
            if (_displaySaveButton == false) {
              setState(() {
                _displaySaveButton = true;
              });
            }
          },
          child: Consumer3<CustomerData, PaymentData, CameraProv>(
              builder: (context, customerData, paymentData, camera, child) {
                customerData.potentialCustomer = customerData.selectedCustomer;

                _firstNameController.text =
                customerData.potentialCustomer.first_name;
            _lastNameController.text = customerData.potentialCustomer.last_name;
            _phoneNumberController.text =
                customerData.potentialCustomer.phoneNumber;
            _addressController.text = customerData.potentialCustomer.address;
            if (camera.picChosen) {

                _displaySaveButton = true;



            }

            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(_conn.coverPicGeneral))),
                  child: const BuildAvatar(),
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: TextFormField(
                          // controller: _firstNameController,
                          initialValue:
                              customerData.potentialCustomer.first_name,
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                          onSaved: (value) {
                            customerData.potentialCustomer.first_name = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              /*  _potentialCustomer.first_name =
                                  customerData.selectedCustomer.first_name;*/
                            }
                          }),
                    ),
                    ListTile(
                      title: TextFormField(
                          //   controller: _lastNameController,
                          initialValue: customerData.potentialCustomer.email,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          onSaved: (value) {
                            customerData.potentialCustomer.email = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              /* _potentialCustomer.email =
                                  customerData.selectedCustomer.email;*/
                            }
                          }),
                    ),
                    ListTile(
                      title: TextFormField(
                          //  controller: _phoneNumberController,
                          initialValue:
                              customerData.potentialCustomer.phoneNumber,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                          ),
                          onSaved: (value) {
                            customerData.potentialCustomer.phoneNumber = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              /*_potentialCustomer.phoneNumber =
                                  customerData.selectedCustomer.phoneNumber;*/
                            }
                          }),
                    ),
                    ListTile(
                      title: TextFormField(
                          // controller: _addressController,
                          initialValue: customerData.potentialCustomer.address,
                          decoration: InputDecoration(
                            labelText: 'Address',
                          ),
                          onSaved: (value) {
                            customerData.potentialCustomer.address = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              /*_potentialCustomer.address =
                                  customerData.selectedCustomer.address;*/
                            }
                          }),
                    ),
                    InstructorDropdownWidget(),
                    (customerData.getSaveButton() || _displaySaveButton)
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: ()  {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    /*_potentialCustomer.customer_id =
                                        customerData
                                            .selectedCustomer.customer_id;*/
                                    customerData.selectedCustomer.staffID ;
                                    /* customerData.modifyCustomer(
                                        _potentialCustomer);*/
                                    customerData.modifyCustomer(
                                        customerData.potentialCustomer);
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          _message = "";
                                          return buildAlertDialog(customerData);
                                        });

                                    //   setState(() {});
                                    //    Scaffold.of(context).closeDrawer();
                                  }
                                },
                                child: Text('Submit  Changes')),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  AlertDialog buildAlertDialog(CustomerData customerData) {
    return AlertDialog(
      actions: [TextButton(onPressed: (){Navigator.of(context).pop();},child: Text("ok"),)],
      content: StreamBuilder<String>(
        stream: customerData.streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //       print("napaan");
            _displaySaveButton = false;
            _message += " ${snapshot.data}";
            return Text(_message);
          } else if (snapshot.hasError) {
            return Text('error : ${snapshot.error}');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<String> _receiveModifyOutput(
      BuildContext context, selectedCustomer) async {
    var messageStream;
    try {
      await for (final value
          in selectedCustomer.modifyCustomer(selectedCustomer)) {
        messageStream += value;
      }
    } catch (e) {
      return "";
    }
    return messageStream;
  }
}
