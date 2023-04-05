import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ateam_accounting_12/Models/CustomerRowData.dart';
import 'package:http/http.dart' as http;

import '../Customer.dart';

class DataBaseConn {
  Customer lastLoadedCustomer = Customer.emptyCustomer();
  String dUrl = "http://www.firstpointsolutions.net/arcaahmet/API/";

  int limit = 50;
  String offset = "";
  String pageSize = "";

  String sortIndex = "";
  String sortAsc = "";

  var dbStreamController = StreamController.broadcast();

  get customerPicUploadFolder => "uploads/";

  get headers => <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
      };

  String get assetProfileImage => "assets/images/profilePic.png";

  String get assetBackgroundImage => "assets/images/background.jpeg";

  String get coverPicGeneral => "assets/images/default_cover_pic.jpeg";

  void deleteProfilePic(CustomerRowData customer) async {
    String _url = "${dUrl}delete_profile_pic.php";

    var queryParameter = <String, String>{
      "filename": "$customerPicUploadFolder${customer.picName}"
    };
    var response = await http.post(Uri.parse(_url),
        headers: headers, body: queryParameter);
    if (response.statusCode == 200) {
      dbStreamController.add(response.body);

    } else {
      dbStreamController.add(response.body);
    }
  }

  String message = "";

  Future<void> uploadImage(File uploadImg, CustomerRowData customer) async {
    message = "";
    String _url = "${dUrl}profile_image_upload.php";
    try {
      List<int> imageBytes = uploadImg.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      //convert file image to Base64 encoding
      var response = await http.post(Uri.parse(_url), body: {
        'image': baseimage,
        'name': customer.picName,
      });
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        message += "\n ${jsondata["msg"]}\n"; //decode json data
        if (jsondata["error"]) {
          //check error sent from server
          dbStreamController.add(message);

          return jsondata["msg"];

          //if error return from server, show message from server
        } else {
          dbStreamController.add(message);

      //    return jsondata["msg"];
        }
      } else {
      //  return "Error during connection to server";
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    } catch (e) {
   //   return "Error during converting to Base64";
      //there is error during converting file image to base64 encoding.
    }
  }

  /* Future<List<Customer>> fetchAllUsers() async {
    String url = "${dUrl}users_to_JSON.php";
    var headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };
    var response = await http.post(Uri.parse(url),
        headers: headers,
        body: (<String, String>{
          "limit": limit.toString(),
          "startID": (lastLoadedCustomer.customer_id).toString(),
          "offset": offset,
          "pageSize": pageSize,
          "sortIndex": sortIndex,
          "sortAsc": sortAsc
        }));
    var decoded = jsonDecode(response.body);
    */ /*   var response = await http.get(Uri.parse(url));
    var decoded = jsonDecode(response.body);*/ /*

    List<Customer> myDecoder = [];

    decoded.forEach((myDecoderVar) {
      myDecoder.add(Customer.fromJson(myDecoderVar));
      // print(myDecoderVar);
      //  print(++i);
    });
    lastLoadedCustomer = myDecoder.last;
    return myDecoder;
    //  User.fromJson(value);
  }
*/
  Future<CustomerRowData> fetchByUserID(String id) async {
    var url = Uri.parse(dUrl + "post_request_id.php");
    var headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };
    var response = await http.post(url,
        headers: headers,
        body: (<String, String>{"customer_id": id.toString()}));
    var decoded = jsonDecode(response.body);

    List<CustomerRowData> customerList = [];
    decoded.forEach((myDecoderVar) {
      customerList.add(CustomerRowData.fromJson(myDecoderVar));
    });

    if (customerList.length == 0) {
      print("empty response body");
      throw new Exception("invalid user");
      /*  return new Customer(
        "NA",
        "NA",
        "NA",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
      );*/
    } else {
      return customerList[0];
    }

    //  User.fromJson(value);
  }

  Future<String> deleteByUserID(String id) async {
    var _url = Uri.parse(dUrl + "delete_customer_by_ID.php");
    var headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };
    var response = await http.post(_url,
        headers: headers, body: (<String, String>{"customer_id": id}));
    var decoded = jsonDecode(response.body);

    return decoded;

    //  User.fromJson(value);
  }
}
