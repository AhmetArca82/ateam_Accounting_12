import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:ateam_accounting_12/Models/PaymentData.dart';
import 'package:ateam_accounting_12/Models/QuickPayment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class QuickPaymentWidget extends StatefulWidget {
  const QuickPaymentWidget({super.key});

  @override
  State<QuickPaymentWidget> createState() {
    return _QuickPaymentWidgetState();
  }
}

class _QuickPaymentWidgetState extends State<QuickPaymentWidget> {
  final _quickPaymentFormKey = GlobalKey<FormState>();

  String? _quickPaymentAmount = "";
  DateTime date = DateTime.now();

  bool displayAddOutcome = false;

  String message = "anan";

  @override
  Widget build(BuildContext context) {
    return Consumer2<QuickPayment, CustomerData>(
        builder: (context, quickPayment, customerData, _) {
      quickPayment.setDisplayAddOutcome(false);
      return LayoutBuilder(builder: (context, constraints) {
        return AnimatedContainer(
          width: quickPayment.displayQuickPayment ? constraints.maxWidth : 0,
          alignment: quickPayment.displayQuickPayment
              ? Alignment.topLeft
              : Alignment.topRight,
          duration: const Duration(milliseconds: 500),
          child: quickPayment.displayQuickPayment
              ? LayoutBuilder(builder: (context, constraints) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                          height: 200,
                          width: (constraints.maxWidth > 600)
                              ? 700
                              : constraints.maxWidth,
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  //  surfaceTintColor: Colors.red[100],
                                  //shape: ,
                                  elevation: 10,
                                  shadowColor: Colors.blue[300],
                                  color: Colors.blue[100],
                                  child: Column(children: [
                                    Row(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(Icons.payment),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Add Quick Payment'),
                                        ),
                                      ],
                                    ),
                                    Form(
                                        onChanged: () {
                                          setState(() {
                                            quickPayment
                                                .setDisplayQuickPaymentSubmit(
                                                    true);
                                            //displayQuickPaymentSubmit = true;
                                          });
                                        },
                                        key: _quickPaymentFormKey,
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 100,
                                              child: TextFormField(
                                                onSaved: (value) {
                                                  quickPayment
                                                      .setQuickPaymentAmount(
                                                          value!);
                                                },
                                                decoration: InputDecoration(
                                                  label: Text('Amount'),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  _quickPaymentAmount = value;
                                                },
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                              child: Text(
                                                  DateFormat('dd/MM/yyy')
                                                      .format(date)),
                                              onTap: () async {
                                                showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(2010),
                                                        lastDate:
                                                            DateTime(2100))
                                                    .then((value) {
                                                  print(value);
                                                  if (value != null) {
                                                    quickPayment
                                                        .setQuickPaymentDate(
                                                            value);
                                                    setState(() {
                                                      date = value;
                                                      quickPayment
                                                          .setQuickPaymentDate(
                                                              value);
                                                    });
                                                  }
                                                });
                                              }),
                                          quickPayment.displayQuickPaymentSubmit
                                              ? ElevatedButton(
                                                  child: Text('Get Payment'),
                                                  onPressed: () {
                                                    _quickPaymentFormKey
                                                        .currentState!
                                                        .validate();
                                                    _quickPaymentFormKey
                                                        .currentState!
                                                        .save();
                                                    quickPayment
                                                        .setQuickPaymentDate(
                                                            date);
                                                    quickPayment.setCustomerID(
                                                        customerData
                                                            .selectedCustomer
                                                            .customer_id);
                                                    quickPayment
                                                        .addQuickPayment()
                                                        .then((value) {
                                                      setState(() {
                                                        if (value ==
                                                            'payment added') {
                                                          message =
                                                              "Payment Added successfully";
                                                          Provider.of<PaymentData>(
                                                                  context,
                                                                  listen: false)
                                                              .offset = 0;
                                                          Provider.of<PaymentData>(
                                                                  context,
                                                                  listen: false)
                                                              .getNextPage();
                                                          //  PaymentTable();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      message)));
                                                        } else {
                                                          message = "yok bok";
                                                          displayAddOutcome =
                                                              true;
                                                        }
                                                      });
                                                    });
                                                  })
                                              : SizedBox.shrink(),
                                        ]))
                                  ])))));
                })
              : SizedBox.shrink(),
        );
      });
    });
  }
}
