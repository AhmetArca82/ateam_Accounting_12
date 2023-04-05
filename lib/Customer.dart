import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:ateam_accounting_12/Models/CustomerRowData.dart';
import 'package:flutter/cupertino.dart';

class Customer {
  String customer_id;
  String first_name;
  String last_name;
  String email;
  String phone_number;
  String address;
  String active;
  String create_date;
  String last_update;
  String clas;
  String staff_id;
  String pic_name;
  String piclink;

  Customer(
      this.customer_id,
      this.first_name,
      this.last_name,
      this.email,
      this.phone_number,
      this.address,
      this.active,
      this.create_date,
      this.last_update,
      this.staff_id,
      this.clas,
      this.piclink,
      this.pic_name) {}
  Map<String, String> toJson() => {
        "customer_id": customer_id.toString(),
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "phone_number": phone_number,
        "address": address,
        "active": active,
        "create_date": create_date,
        "last_update": last_update,
        "staff_id": staff_id,
        "class": clas,
        "piclink": piclink,
        "pic_name": pic_name,
      };
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      json['customer_id'] as String,
      json['first_name'] as String,
      json['last_name'] as String,
      json['email'] ?? "" as String,
      json['phone_number'] as String,
      json['address'] ?? "",
      json['active'] ?? "0",
      json['create_date'] ?? "",
      json['last_update'] ?? "",
      json['staff_id'] ?? "",
      json['class'] ?? "",
      json['piclink'] ?? "",
      json['pic_name'] ?? "",
    );
  }

  static Customer emptyCustomer() {
    return Customer(
        "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0");
  }
}

class MyCustomerListTile extends StatelessWidget {
  const MyCustomerListTile({
    Key? key,
    required CustomerRowData data,
  })  : _data = data,
        super(key: key);

  final CustomerRowData _data;

  @override
  Widget build(BuildContext context) {
    return _data.buildListTile(_data);
  }
}