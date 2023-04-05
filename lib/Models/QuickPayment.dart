import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuickPayment with ChangeNotifier {
  bool displayQuickPayment = false;
  bool displayQuickPaymentSubmit = false;
  String StaffID = "";
  String? quickPaymentAmount;
  bool displayAddOutcome = false;

  void setDisplayAddOutcome(bool display) {
    displayAddOutcome = display;
    //notifyListeners();
  }

  DateTime quickPaymentDate = DateTime.now();

  var customerID = "";

  void setCustomerID(String ID) {
    customerID = ID;
    notifyListeners();
  }

  void setDisplayQuickPayment(bool display) {
    displayQuickPayment = display;
    notifyListeners();
  }

  void setDisplayQuickPaymentSubmit(bool display) {
    displayQuickPaymentSubmit = display;
  }

  void setQuickPaymentAmount(String amount) {
    quickPaymentAmount = amount;
    notifyListeners();
  }

  void setQuickPaymentDate(DateTime value) {
    quickPaymentDate = value;
    notifyListeners();
  }

  Future<String> addQuickPayment() async {
    //  print(
    //      "next page unloaded with offset: ${offset} pagesize: ${pageSize}  the last customer was :${customerDataRowList.length}");
    String _dUrl = "http://www.firstpointsolutions.net/arcaahmet/API/";
    String _url = "${_dUrl}add_quick_payment.php";
    var headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };
    final queryParameter = <String, String>{
      "customer_id": customerID,
      "payment_amount": quickPaymentAmount!,
      "payment_date": quickPaymentDate.toString(),
    };
    //final requestUri = Uri.http(_url, queryParameter);
    var response = await http.post(Uri.parse(_url),
        headers: headers, body: queryParameter);
    var decodedJson;
    if (response.statusCode == 200) {
      //displayAddOutcome = true;
      setDisplayAddOutcome(true);
      displayQuickPayment = false;
      notifyListeners();
      return response.body;
    }
    //   return customerDataRowList;
    else {
      throw Exception('unable to query remote server');
    }
  }
}
