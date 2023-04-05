import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:ateam_accounting_12/Models/PaymentData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviousPaymentsOfCustomerWidget extends StatefulWidget {
  @override
  State<PreviousPaymentsOfCustomerWidget> createState() {
    return _PreviousPaymentsOfCustomerWidgetState();
  }
}

class _PreviousPaymentsOfCustomerWidgetState
    extends State<PreviousPaymentsOfCustomerWidget> {
  bool _showPayments = false;

  //var _tempCust = PaymentRowData.cleanPayment();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer2<CustomerData, PaymentData>(
        builder: (context, customers, paymentData, _) {
          return SingleChildScrollView(
            child: (paymentData.customerPayments.isEmpty)
                ? SizedBox.shrink()
                : Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(border: Border.all()),
                    child: ListView.builder(
                        itemCount: paymentData.customerPayments.length,
                        itemBuilder: (context, index) {
                          if (paymentData.customerPayments.length != 0) {
                            return ListTile(
                              leading: Text(paymentData
                                  .customerPayments[index].payment_id),
                              trailing: Text(
                                  "${paymentData.customerPayments[index].paymentAmount}  ${paymentData.customerPayments[index].paymentDate.substring(0, 10)}"),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                  ),
          );

          /*   FutureBuilder(
            future: paymentData
                .getCustomerPayments(customers.selectedCustomer.customer_id),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(border: Border.all()),
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data.length != 0) {
                            return ListTile(
                              leading: Text(snapshot.data[index].payment_id),
                              trailing: Text(
                                  "${snapshot.data[index].paymentAmount}  ${snapshot.data[index].paymentDate.substring(0, 10)}"),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Text('we have made a boo boo');
              } else {
                return CircularProgressIndicator();
              }
            },
          );*/
        },
      ),
    );
  }
}
