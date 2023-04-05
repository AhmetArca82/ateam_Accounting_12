import 'package:ateam_accounting_12/API/DataBaseConn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CustomerRowData {
  bool isSelected = false;
  bool deleted = false;
  String customer_id;
  String first_name;
  String last_name;
  String email;
  String phoneNumber;
  String address;
  String active;
  String createDate;
  String lastUpdate;
  String staffID;
  String classAttended;
  String picLink;
  String picName;
  final String customerPicUploadFolder = "uploads/";

  factory CustomerRowData.fromJson(Map<String, dynamic> json) {
    return CustomerRowData(
        json['customer_id'] as String,
        json['first_name'] as String,
        json['last_name'] as String,
        json['email'] as String,
        json['phone_number'] as String,
        json['address'] as String,
        json['active'] as String,
        json['create_date'] as String,
        json['last_update'] as String,
        (json['staff_id'] == null) ? "1" : json['staff_id'] as String,
        json['class'] as String,
        json['piclink'] as String,
        json['pic_name'] as String);
  }

  CustomerRowData(
    this.customer_id,
    this.first_name,
    this.last_name,
    this.email,
    this.phoneNumber,
    this.address,
    this.active,
    this.createDate,
    this.lastUpdate,
    this.staffID,
    this.classAttended,
    this.picLink,
    this.picName,
  );

  get _fileExtension => "_profile_pic.jpg";

  Map<String, dynamic> toJson(CustomerRowData customer) {
    Map<String, dynamic> CustomerMap = {
      'customer_id': customer.customer_id,
      'first_name': customer.first_name,
      'last_name': customer.last_name,
      'email': customer.email,
      'phone_number': customer.phoneNumber,
      'address': customer.address,
      'active': customer.active,
      'create_date': customer.createDate,
      'last_update': customer.lastUpdate,
      'staff_id': customer.staffID,
      'class': customer.classAttended,
      'piclink': customer.picLink,
      'pic_name': customer.picName
    };
    return CustomerMap;
  }

  var _conn = DataBaseConn();
  bool customerNotEdited(CustomerRowData other){
    return customer_id==other.customer_id &&
        first_name == other.first_name &&
        last_name ==other.last_name &&
        email==other.email &&
        phoneNumber == other.phoneNumber &&
    address ==other.address &&
    active ==other.active &&
    createDate == other.createDate&&
    lastUpdate == other.lastUpdate &&
    staffID ==other.staffID &&
    classAttended == other.classAttended &&
    picLink ==other.picLink &&
    picName == other.picName;


  }

  void generateLink() {
    if (customer_id != null) {
      picName = "$customer_id$_fileExtension";
      // var _dUrl = _conn.dUrl;
      picLink = "${_conn.dUrl}${_conn.customerPicUploadFolder}$picName";
    }
  }

  Widget buildListTile(CustomerRowData _data) {
    return Container(
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_data.customer_id),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_data.first_name),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_data.last_name),
        ),
      ]),
    );
  }

  static CustomerRowData emptyForm() {
    return CustomerRowData("", "", "", "", "", "", "", "", "", "", "", "", "");
  }
}
