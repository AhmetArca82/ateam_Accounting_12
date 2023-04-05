import 'package:ateam_accounting_12/Models/PaymentData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  @override
  State<SearchBar> createState() {
    return _SearchBarState();
  }
}

class _SearchBarState extends State<SearchBar> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
                border: InputBorder.none, labelText: 'Search Payments'),
            onChanged: (searchTerm) {
              Provider.of<PaymentData>(context, listen: false)
                  .setSearchTerm(searchTerm);
              Provider.of<PaymentData>(context, listen: false).setOffset(0);
              Provider.of<PaymentData>(context, listen: false)
                  .paymentDataRowList
                  .clear();
              Provider.of<PaymentData>(context, listen: false).getNextPage();
            },
          ),
        ),
      ),
    );
  }
}