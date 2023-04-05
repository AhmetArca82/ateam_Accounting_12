import 'dart:convert';

import 'package:ateam_accounting_12/API/DataBaseConn.dart';
import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  @override
  State<TestPage> createState() {
    return _TestPageState();
  }
}

class _TestPageState extends State<TestPage> {
  var _controller = TextEditingController();
  String inputID = "";
  var _conn = DataBaseConn();


  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerData>(
      builder: (context, customerData, _) {
        return Column(
          children: [
            TextFormField(
              controller: _controller,
              onSaved: (value) {
                setState(() {
                  inputID = value!;
                });
              },
            ),
            TextButton(
                onPressed: () async {
                  customerData
                      .deleteProfilePic(
                      await _conn.fetchByUserID(_controller.text));
                },
                child: Text("Delete User picture")),
            StreamBuilder<String>(
                stream: customerData.streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var deneme = jsonDecode(snapshot.data!);
                    return deneme["msg"];
                  } else if (snapshot.hasError) {
                    return Text("there is an error in the delete function");
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ],
        );
      },
    );
  }
}
