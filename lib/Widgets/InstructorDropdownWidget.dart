import 'package:ateam_accounting_12/API/DataBaseConn.dart';
import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:ateam_accounting_12/Models/InstructorData.dart';
import 'package:ateam_accounting_12/Models/InstructorRowData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstructorDropdownWidget extends StatefulWidget {
  @override
  State<InstructorDropdownWidget> createState() {
    return _InstructorDropdownWidgetState();
  }
}

class _InstructorDropdownWidgetState extends State<InstructorDropdownWidget> {
  bool _isExpanded = false;
  var _conn = DataBaseConn();
  String dropDownValue = '1';

  @override
  void initState() {
    super.initState();
    Provider.of<CustomerData>(context, listen: false)
        .potentialCustomer
        .staffID = "1";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InstructorData>(builder: (context, instructorData, _) {
      if (instructorData.instructorDataRowList.isEmpty) {
        return FutureBuilder(
          future: Provider.of<InstructorData>(context, listen: false)
              .fetchAllInstructors(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<InstructorRowData> temp = snapshot.data;

              return Container(
                decoration: BoxDecoration(color: Colors.grey[100]),
                //decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: DropdownButton(
                  hint: Text('choose instructor'),
                  underline: SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(20),
                  isExpanded: true,
                  value: dropDownValue,
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  elevation: 16,
                  items: temp.map((InstructorRowData instructor) {
                    return DropdownMenuItem<String>(
                      value: instructor.staff_id,
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                  '${instructor.first_name.substring(0, 1).toUpperCase()}'),
                              backgroundImage:
                                  AssetImage(_conn.assetProfileImage),
                            ),
                            title: Text(
                                " ${instructor.first_name} ${instructor.last_name}"),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                     dropDownValue = value ?? "1";
/*
                      Provider.of<CustomerData>(context, listen: false)
                          .potentialCustomer
                          .staffID = value!;*/
                      _isExpanded = false;

                    });
                    Provider.of<CustomerData>(context, listen: false).setStaffID(Cust.potential, value!);


                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text('we made a boo boo');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      } else {
        return DropdownButton(
          underline: SizedBox.shrink(),
          borderRadius: BorderRadius.circular(20),
          isExpanded: true,
          value: dropDownValue,
          icon: const Icon(Icons.arrow_drop_down_circle_outlined),
          elevation: 16,
          items: instructorData.instructorDataRowList
              .map((InstructorRowData instructor) {
            return DropdownMenuItem<String>(
              value: instructor.staff_id,
              child: Center(
                child: Container(
                  width: double.infinity,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(_conn.assetProfileImage),
                      child: Text(
                        '${instructor.first_name.substring(0, 1).toUpperCase()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    title: Text(
                        " ${instructor.first_name} ${instructor.last_name}"),
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? value) {

            setState(() {


              dropDownValue = value ?? "1";
              /*Provider.of<CustomerData>(context, listen: false)
                  .potentialCustomer
                  .staffID = value!;*/
              _isExpanded = false;
            });
            Provider.of<CustomerData>(context, listen: false).setStaffID(Cust.potential, value!);
          },
        );
      }
    });
  }
}
