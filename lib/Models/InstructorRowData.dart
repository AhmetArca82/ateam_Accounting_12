import 'package:flutter/cupertino.dart';

class InstructorRowData {
  String staff_id;
  String first_name;
  String last_name;
  String email;
  String address;
  String active;
  String create_date;
  String last_update;

  factory InstructorRowData.fromJson(Map<String, dynamic> json) {
    return InstructorRowData(
      json['staff_id'] as String,
      json['first_name'] as String,
      json['last_name'] as String,
      json['email'] as String,
      json['address'] as String,
      json['active'] as String,
      json['create_date'] as String,
      json['last_update'] as String,
    );
  }

  InstructorRowData(
    this.staff_id,
    this.first_name,
    this.last_name,
    this.email,
    this.address,
    this.active,
    this.create_date,
    this.last_update,
  );

  Map<String, dynamic> toJson(InstructorRowData instructor) {
    Map<String, dynamic> CustomerMap = {
      'staff_id': instructor.staff_id,
      'first_name': instructor.first_name,
      'last_name': instructor.last_name,
      'email': instructor.email,
      'active': instructor.active,
      'create_date': instructor.create_date,
      'last_update': instructor.last_update,
    };
    return CustomerMap;
  }

  Widget buildListTile(InstructorRowData _data) {
    return Container(
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_data.staff_id),
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

  static InstructorRowData emptyForm() {
    return InstructorRowData("", "", "", "", "", "", "", "");
  }
}