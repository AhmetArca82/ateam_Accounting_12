import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:ateam_accounting_12/Models/CustomerRowData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerChangeForm extends StatefulWidget {
  // const PaymentChangeForm({super.key});
  @override
  State<CustomerChangeForm> createState() {
    return _CustomerChangeFormState();
  }
}

class _CustomerChangeFormState extends State<CustomerChangeForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;
  CustomerRowData? _data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Change Form'),
      ),
      body: Center(
        child: Container(
          width: 200,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Consumer<CustomerData>(
                builder: (context, customerinfo, child) {
                  _data = customerinfo.selectedCustomer;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'Customer ID: ${customerinfo.selectedCustomer.customer_id}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue:
                              customerinfo.selectedCustomer.first_name,
                          decoration: InputDecoration(labelText: 'name'),
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