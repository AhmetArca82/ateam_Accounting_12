// The "source" of the table
import 'dart:convert';

import 'package:ateam_accounting_12/API/DataBaseConn.dart';
import 'package:ateam_accounting_12/Models/PaymentRowData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentData extends ChangeNotifier {
  PaymentRowData selectedPayment = PaymentRowData.cleanPayment();
  var sortAscending;
  int initialPosition = 0;
  int finalPosition = 0;
  int totalNoOfRows = 0;
  List<PaymentRowData> paymentDataRowList = [];
  List<String> selectedIds = [];
  String lastSearchTerm = '';
  int rowsPerPage = 10;
  int offset = 0;
  int columnSortIndex = 1;
  int pageSize = 10;
  int noOfItemsBrought = 0;
  int currentPageSize = 10;
  bool isScrolled = false;
  var _conn = DataBaseConn();
  bool customerHasNoPayments = false;

  int get rowCount => paymentDataRowList.length;

  void setIsScrolled(bool scroll) {
    isScrolled = scroll;
  }

  int get selectedRowCount => 0;

  bool get isRowCountApproximate => false;

  Future getNextPage() async {
    //  print("next page unloaded");
    if (!isScrolled) {
      offset = 0;
      paymentDataRowList.clear();
    }
    String _dUrl = "http://www.firstpointsolutions.net/arcaahmet/API/";
    String _url = _dUrl + "dataTablePayments.php";
    var headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };

    final queryParameter = <String, String>{
      "offset": offset.toString(),
      "pageSize": (pageSize).toString(),
      "sortIndex": (columnSortIndex).toString(),
      "sortAsc": (sortAscending).toString(),
      "searchTerm": searchTerm,
    };
    //final requestUri = Uri.http(_url, queryParameter);
    var response = await http.post(Uri.parse(_url),
        headers: headers, body: queryParameter);
    var decodedJson;
    if (response.statusCode == 200) {
      decodedJson = jsonDecode(response.body);

      decodedJson['payment'].forEach((myDecoderVar) {
        paymentDataRowList.add(PaymentRowData.fromJson(myDecoderVar));
      });

      finalPosition += pageSize;
      initialPosition = finalPosition - pageSize;
      totalNoOfRows = int.parse(decodedJson['tableRowCount'][0]);
      shouldLoad = false;
      notifyListeners();
    } else {
      throw Exception('unable to query remote server');
    }
  }

  bool shouldLoad = true;

  void setSelectedPayment(PaymentRowData data) {
    selectedPayment = data;
    notifyListeners();
  }

  String searchTerm = "";

  void setSearchTerm(String searchLetters) {
    searchTerm = searchLetters;
  }

  void setOffset(int i) {
    offset = i;
  }

  List<PaymentRowData> customerPayments = [];

  Future getCustomerPayments(customerID) async {
    customerPayments.clear();
    String _url = _conn.dUrl + "customer_payments_by_ID.php";
    var headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };

    final queryParameter = <String, String>{
      "customerID": customerID,
    };
    //final requestUri = Uri.http(_url, queryParameter);
    var response = await http.post(Uri.parse(_url),
        headers: headers, body: queryParameter);
    var decodedJson;
    if (response.statusCode == 200) {
      decodedJson = jsonDecode(response.body);
      print("${decodedJson} \n");
      decodedJson['payment'].forEach((myDecoderVar) {
        customerPayments.add(PaymentRowData.fromJson(myDecoderVar));
      });
      (customerPayments.isEmpty)
          ? customerHasNoPayments = true
          : customerHasNoPayments = false;
      //notifyListeners();
    } else {
      throw Exception('unable to query remote server');
    }

    return customerPayments;
  }

  Future deletePayment(PaymentRowData data) async {
    String _dUrl = "http://www.firstpointsolutions.net/arcaahmet/API/";
    String _url = _dUrl + "delete_payment_by_id.php";
    var headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };

    final queryParameter = <String, String>{
      "payment_id": data.payment_id,
    };
    //final requestUri = Uri.http(_url, queryParameter);
    var response = await http.post(Uri.parse(_url),
        headers: headers, body: queryParameter);
    var decodedJson;
    if (response.statusCode == 200) {
      selectedPayment = PaymentRowData.cleanPayment();
      offset = 0;
      getNextPage();
      //notifyListeners();
      return response.body;
    } else {
      // throw Exception('unable to query remote server');
      return "Unable to Query Remote Server";
    }
  }
}
