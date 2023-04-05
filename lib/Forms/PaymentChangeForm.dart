import 'package:ateam_accounting_12/Models/PaymentData.dart';
import 'package:ateam_accounting_12/Models/PaymentRowData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentChangeForm extends StatefulWidget {
  // const PaymentChangeForm({super.key});
  @override
  State<PaymentChangeForm> createState() {
    return _PaymentChangeFormState();
  }
}

class _PaymentChangeFormState extends State<PaymentChangeForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;
  PaymentRowData? _data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Change Form'),
      ),
      body: Center(
        child: Container(
          width: 200,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Consumer<PaymentData>(
                builder: (context, paymentinfo, child) {
                  _data = paymentinfo.selectedPayment;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'Payment ID: ${paymentinfo.selectedPayment.payment_id}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: paymentinfo.selectedPayment.customerID,
                          decoration: InputDecoration(labelText: 'Customer ID'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _name = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // Do something with the form data
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}