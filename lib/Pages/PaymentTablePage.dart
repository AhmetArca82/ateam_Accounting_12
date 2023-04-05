import 'package:ateam_accounting_12/DataTable/PaymentTable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentTablePage extends StatefulWidget {
  // const PaymentChangeForm({super.key});
  @override
  State<PaymentTablePage> createState() {
    return _PaymentTablePageState();
  }
}

class _PaymentTablePageState extends State<PaymentTablePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar:,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/PaymentChangeForm');
          setState(() {});
        },
        tooltip: 'pcf',
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [Expanded(child: PaymentTable())],
        ),
      ),
    );
  }
}