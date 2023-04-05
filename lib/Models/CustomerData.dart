// The "source" of the table
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ateam_accounting_12/API/DataBaseConn.dart';
import 'package:ateam_accounting_12/Customer.dart';
import 'package:ateam_accounting_12/Models/CameraProv.dart';
import 'package:ateam_accounting_12/Models/CustomerRowData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


enum Cust {potential,selected}
class CustomerData extends ChangeNotifier {
   File? _uploadImageFile;
   File? get  uploadImageFile=>_uploadImageFile;

   set uploadImageFile(File? image){
     _uploadImageFile =image;
     notifyListeners();

   }



   String _message="";
String get message =>_message;
set message(String message){
  _message=message;
  notifyListeners();
}

void appendMessage(String message){
  _message+=message;
}




  CameraProv camera = CameraProv();
  bool displaySaveButton = false;
  String searchTerm = "";






  CustomerRowData selectedCustomer = CustomerRowData.emptyForm();
  CustomerRowData potentialCustomer = CustomerRowData.emptyForm();
  var sortAscending;
  bool shouldLoad = true;
  int totalNoOfRows = 0;
  List<CustomerRowData> customerDataRowList = [];
  List<String> selectedIds = [];
  String lastSearchTerm = '';
  int rowsPerPage = 10;
  int offset = 0;
  int columnSortIndex = 1;
  int pageSize = 10;
  int noOfItemsBrought = 0;
  int currentPageSize = 10;
  var _conn = DataBaseConn();
  bool isScrolled = false;

  bool _displaySaveButtons=false;
  void setStaffID(var hh ,String value){
switch (hh){
  case Cust.potential:
    potentialCustomer.staffID =value;
    _displaySaveButtons=true;
notifyListeners();
    break;
  case Cust.selected:
    selectedCustomer.staffID =value;
    _displaySaveButtons=true;
    notifyListeners();
    break;
  default:
    print("nothing was done in terms of staff Id Im in setStaffID");
    _displaySaveButtons=true;

    break;
}




  }

  void setPotentialCustomer(CustomerRowData potential) {
    potentialCustomer = potential;
    notifyListeners();
  }

  Future getNextPage() async {
    String _dUrl = "http://www.firstpointsolutions.net/arcaahmet/API/";
    String _url = _dUrl + "dataTablePaginatedGetNextPage.php";
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
      decodedJson['Customer'].forEach((myDecoderVar) {
        customerDataRowList.add(CustomerRowData.fromJson(myDecoderVar));
      });
      totalNoOfRows = int.parse(decodedJson['tableRowCount'][0]);
      shouldLoad = false;
      notifyListeners();
    } else {
      throw Exception('unable to query remote server');
    }
  }

  void setSelectedCustomer(CustomerRowData data) {
    selectedCustomer = data;
    notifyListeners();
  }

  void setOffset(int i) {
    offset = i;
  }

  void setSearchTerm(String searchLetters) {
    searchTerm = searchLetters;
  }

  void setIsScrolled(bool bool) {
    isScrolled = bool;
  }

  StreamController<String> streamController =
      StreamController<String>.broadcast();

  Stream<String> get messageStream => streamController.stream;



  Future<void> modifyCustomer(CustomerRowData potentialCustomer) async {
    //message = "";
    if (potentialCustomer.picName=="") potentialCustomer.generateLink();
   // if (selectedCustomer.picName=="") selectedCustomer.generateLink();
  /*  if (uploadImageFile != null ) {
     //   deleteProfilePic(potentialCustomer);
      appendMessage("waiting for uploading \n");

        uploadImage(potentialCustomer);
        appendMessage( "waiting for uploading \n");
        notifyListeners();
    }*/
    if(!potentialCustomer.customerNotEdited(selectedCustomer)) {

      if (potentialCustomer.staffID.isEmpty ||
          potentialCustomer.staffID == "" ) {
        potentialCustomer.staffID = "1";
      }

      final queryParameter = potentialCustomer.toJson(potentialCustomer);
      String _url = "${_conn.dUrl}modifyUser.php";
      var response = await http.post(Uri.parse(_url),
          headers: _conn.headers, body: queryParameter);
      appendMessage("waiting for the modify customer back end service \n");
      if (response.statusCode == 200) {
        appendMessage(response.body);
        streamController.add(response.body);
      }else {
        appendMessage("we went to an exception on line 133 \n");
       // streamController.add("we went to an exception on line 133");
        throw Exception('unable to query remote server');
      }
      streamController.add(message);
    }
  }

  void uploadImage(CustomerRowData potentialCustomer)  {
    if(potentialCustomer.picName.isEmpty)  generateLink(potentialCustomer);
      _conn.uploadImage(_uploadImageFile!, potentialCustomer);
   // _uploadImageFile = null;
    _conn.dbStreamController.stream.listen((event) {
      appendMessage("\n $event \n");
      // streamController.add(message);
    });
    streamController.add(message);
    _uploadImageFile =null;
  }

  CustomerRowData generateLink(CustomerRowData selectedCustomer) {
    selectedCustomer.picName =
        selectedCustomer.customer_id + "_profile_pic.jpg";
    selectedCustomer.picLink =
        "${_conn.dUrl}uploads/${selectedCustomer.picName}";
    return selectedCustomer;
  }

  void deleteProfilePic(CustomerRowData customer) {
    _conn.deleteProfilePic(customer);
    _conn.dbStreamController.stream.listen((event) {
      streamController.add(event);
      print(event);
      appendMessage( "\n $event \n");
    });

  //  clearUploadImage();
  }

  void addNewCustomer() async {
    var createDate = DateTime.now().toString();
    potentialCustomer.createDate = createDate;
    potentialCustomer.generateLink();

    String _url = "${_conn.dUrl}add_new_user.php";
    var headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };
potentialCustomer.generateLink();
    final queryParameter = potentialCustomer.toJson(potentialCustomer);
    var response = await http.post(Uri.parse(_url),
        headers: headers, body: queryParameter);
    if (response.statusCode == 200) {
      streamController.add("post request:  ${response.body}\n");
      if (response.body == "error") {
        streamController
            .add("post request: there was an error adding to database");
      } else {
        potentialCustomer.customer_id = response.body;
        uploadImage(potentialCustomer);
        _conn.dbStreamController.stream.listen((event) {
          streamController.add(event);
          message += event;

        });
      }
    } else {
      streamController.add("unable to query remote server");
    }
  }

  void setSaveButtonsOff() {
    _displaySaveButtons=false;
 //   notifyListeners();
  }
  bool getSaveButton(){
    return _displaySaveButtons;
  }
  void setSaveButtonsOn(){
    _displaySaveButtons=true;
  //  notifyListeners();
  }


}
