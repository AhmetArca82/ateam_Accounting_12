import 'package:ateam_accounting_12/API/DataBaseConn.dart';
import 'package:ateam_accounting_12/Widgets/FormWidget.dart';
import 'package:ateam_accounting_12/Widgets/PreviousPaymentsOfCustomerWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  @override
  State<DrawerWidget> createState() {
    return _DrawerWidgetState();
  }
}

class _DrawerWidgetState extends State<DrawerWidget> {
  var _conn = DataBaseConn();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              opacity: 0.2,
              image: AssetImage(_conn.assetBackgroundImage))),
      child: ListView(
        children: [
          FormWidget(),
          PreviousPaymentsOfCustomerWidget(),
        ],
      ),
    );
  }
}
