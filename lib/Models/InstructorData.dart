import 'dart:convert';

import 'package:ateam_accounting_12/Models/InstructorRowData.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class InstructorData extends ChangeNotifier {
  List<InstructorRowData> instructorDataRowList = [];

  int totalNoOfRows = 0;

  bool shouldLoad = false;

  InstructorRowData? selectedInstructor;

  String? selectedInstructorID;

  Future fetchAllInstructors() async {
    instructorDataRowList.clear();

    //  print(
    //      "next page unloaded with offset: ${offset} pagesize: ${pageSize}  the last customer was :${customerDataRowList.length}");
    String _dUrl = "http://www.firstpointsolutions.net/arcaahmet/API/";
    String _url = _dUrl + "fetch_all_instructors.php";
    var headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };

    var response = await http.get(Uri.parse(_url), headers: headers);

    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      decodedJson['instructors'].forEach((myDecoderVar) {
        instructorDataRowList.add(InstructorRowData.fromJson(myDecoderVar));
      });

      //   totalNoOfRows = int.parse(decodedJson['tableRowCount'][0]);
      shouldLoad = false;

      notifyListeners();
      return instructorDataRowList;
      //   return customerDataRowList;
    } else {
      throw Exception('unable to query remote server');
    }
  }
}