import 'package:ateam_accounting_12/Models/PaymentData.dart';
import 'package:ateam_accounting_12/Models/PaymentRowData.dart';
import 'package:ateam_accounting_12/Widgets/SearchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PaymentTable extends StatefulWidget {
  const PaymentTable({Key? key}) : super(key: key);

  @override
  State<PaymentTable> createState() {
    return _MyPaymentTableState();
  }
}

class _MyPaymentTableState extends State<PaymentTable> {
  bool shouldLoad = true;
  ScrollController paymentScroller = ScrollController();
  final searchController = TextEditingController();

  bool _askConfirmation = false;

  bool _deleteConfirmed = false;

  final listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    paymentScroller.addListener(() {
      if (paymentScroller.position.maxScrollExtent ==
          paymentScroller.position.pixels) {
        shouldLoad = true;
        Provider
            .of<PaymentData>(context, listen: false)
            .offset =
            Provider
                .of<PaymentData>(context, listen: false)
                .paymentDataRowList
                .length;
        Provider.of<PaymentData>(context, listen: false).setIsScrolled(true);
        Provider.of<PaymentData>(context, listen: false).getNextPage();
        shouldLoad = !shouldLoad;
      }
    });
  }

  @override
  dispose() {
    paymentScroller.dispose();
    super.dispose();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    //  print('updated whole table');
    return Stack(
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //        crossAxisCount: 2, mainAxisExtent: 600),
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight / 8,
                      child: SearchBar()),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Consumer<PaymentData>(
                      builder: (context, paymentSource, _) {
                        return Material(
                          child: Container(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight * 7 / 8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all()),
                            child: RefreshIndicator(
                              onRefresh: () async {
                                paymentSource.paymentDataRowList.clear();
                                paymentSource.offset = 0;
                                await paymentSource.getNextPage();
                              },
                              child: ListView.builder(
                                  controller: paymentScroller,
                                  itemCount:
                                  paymentSource.paymentDataRowList.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    var data =
                                    paymentSource.paymentDataRowList[index];
                                    return ListTile(
                                      selected: selectedIndex == index,
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                        data.isSelected = true;
                                        paymentSource.setSelectedPayment(data);
                                      },
                                      selectedTileColor: Colors.black12,
                                      leading: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.lightBlue[50],
                                              borderRadius:
                                              BorderRadius.circular(5)),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  8.0),
                                              child: Text(data.payment_id),
                                            ),
                                          )),
                                      title: Text(
                                          "${data.first_name} ${data
                                              .last_name}"),
                                      subtitle: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("${data.paymentAmount} TL"),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: 2,
                                              height: 20,
                                              color: Colors.white60,
                                            ),
                                          ),
                                          Text(
                                              data.paymentDate.substring(0, 10))
                                        ],
                                      ),
                                      trailing: PopupMenuButton(
                                        onSelected: (String value) {
                                          print("you cliced on popupmenutitem");
                                          actionPopupItemSelected(data, value);
                                        },
                                        itemBuilder: (context) {
                                          return [
                                            const PopupMenuItem(
                                                value: 'delete',
                                                child: ListTile(
                                                  leading:
                                                  Icon(Icons.delete_forever),
                                                  title: Text('delete'),
                                                )),
                                            const PopupMenuItem(
                                                value: 'edit',
                                                child: (ListTile(
                                                  leading: Icon(Icons.edit),
                                                  title: Text('edit'),
                                                )))
                                          ];
                                        },
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]);
          }),
        ]);
  }

  void actionPopupItemSelected(PaymentRowData data, String value) {
    String message;
    if (value == 'edit') {
      message = 'you selected edit for ';
    } else {
      message = 'you selected delete for ';
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              scrollable: true,
              title: const Text('please confirm'),
              content: Column(
                // itemExtent: 10,
                // shrinkWrap: true,
                children: [
                  const Text('Are you sure you want to delete '),
                  Text(
                    'Payment Details',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6,
                  ),
                  DataTable(
                    columns: [
                      DataColumn(label: Text('')),
                      DataColumn(label: Text(''))
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text("Payment ID")),
                        DataCell(Text(data.payment_id)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Customer Name')),
                        DataCell(Text("${data.first_name} ${data.last_name}")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Payment Amount :')),
                        DataCell(Text("${data.paymentAmount}"))
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Payment Date :")),
                        DataCell(Text(data.paymentDate)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Instructor Name :")),
                        DataCell(Text(
                            " ${data.instrFirstName} ${data.instrLastName}"))
                      ])
                    ],
                  )
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Provider.of<PaymentData>(context, listen: false)
                          .deletePayment(data)
                          .then((value) {
                        if (value == 'deleted') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "The payment  ${data.payment_id} from ${data
                                      .first_name} ${data
                                      .last_name} has been deleted ")));
                        }
                      });
                      Navigator.of(context).pop();
                      setState(() {
                        _deleteConfirmed = true;
                      });
                    },
                    child: const Text('Yes')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _deleteConfirmed = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'))
              ],
            );
          });
    }
    print(message);
  }
}
