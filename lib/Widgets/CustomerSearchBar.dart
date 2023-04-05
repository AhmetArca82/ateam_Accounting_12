import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerSearchBar extends StatefulWidget {
  @override
  State<CustomerSearchBar> createState() {
    return _CustomerSearchBarState();
  }
}

class _CustomerSearchBarState extends State<CustomerSearchBar> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        //  width: 300,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: const TextStyle(),
                textAlign: TextAlign.start,
                controller: searchController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  label: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Search Customers',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                onChanged: (searchTerm) {
                  Provider.of<CustomerData>(context, listen: false)
                      .setSearchTerm(searchTerm);
                  Provider.of<CustomerData>(context, listen: false)
                      .setOffset(0);
                  Provider.of<CustomerData>(context, listen: false)
                      .customerDataRowList
                      .clear();
                  Provider.of<CustomerData>(context, listen: false)
                      .getNextPage();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}