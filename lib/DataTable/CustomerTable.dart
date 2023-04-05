import 'package:ateam_accounting_12/API/DataBaseConn.dart';
import 'package:ateam_accounting_12/Forms/CustomerChangeForm.dart';
import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:ateam_accounting_12/Models/PaymentData.dart';
import 'package:ateam_accounting_12/Models/QuickPayment.dart';
import 'package:ateam_accounting_12/Widgets/CustomerSearchBar.dart';
import 'package:ateam_accounting_12/Widgets/QuickPaymentWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../Models/CustomerRowData.dart';

class CustomerTable extends StatefulWidget {
  @override
  State<CustomerTable> createState() {
    return _CustomerTableState();
  }
}

enum Actions { edit, delete, archive }

class _CustomerTableState extends State<CustomerTable> {
  DateTime date = DateTime.now();
  bool _displayQuickPaymentSubmit = false;
  final _conn = DataBaseConn();
  bool shouldLoad = true;
  bool _displayQuickPayment = false;
  ScrollController _customerScroller = ScrollController();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _customerScroller.addListener(() {
      if (_customerScroller.position.maxScrollExtent ==
          _customerScroller.position.pixels) {
        shouldLoad = true;
        Provider.of<CustomerData>(context, listen: false).offset =
            Provider.of<CustomerData>(context, listen: false)
                .customerDataRowList
                .length;
        Provider.of<CustomerData>(context, listen: false).setIsScrolled(true);
        Provider.of<CustomerData>(context, listen: false).getNextPage();
        shouldLoad = !shouldLoad;
      }
    });
  }

  @override
  dispose() {
    _customerScroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(children: [
        SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          // color: Colors.red[100],
          child: Column(
            children: [
              Center(
                child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight / 8,
                    child: CustomerSearchBar()),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Consumer<CustomerData>(
                      builder: (context, customerSource, _) {
                    return Material(
                      child: Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * 7 / 8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all()),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              customerSource.customerDataRowList.clear();
                              customerSource.offset = 0;
                              await customerSource.getNextPage();
                            },
                            child: ListView.builder(
                                controller: _customerScroller,
                                itemCount:
                                    customerSource.customerDataRowList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var data =
                                      customerSource.customerDataRowList[index];
                                  return Slidable(
                                      startActionPane: ActionPane(
                                        motion: const StretchMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              customerSource
                                                  .setSelectedCustomer(data);
                                              _onDismissed(
                                                  data, index, Actions.delete);
                                              customerSource.offset = 0;
                                              customerSource.customerDataRowList
                                                  .clear();
                                              customerSource.getNextPage();

                                              setState(() {});
                                            },
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          )
                                        ],
                                      ),
                                      child: GestureDetector(
                                          onDoubleTap: () async {
                                            customerSource
                                                .setSelectedCustomer(data);
                                            await Provider.of<PaymentData>(
                                                    context,
                                                    listen: false)
                                                .getCustomerPayments(
                                                    data.customer_id);
                                            Scaffold.of(context).openDrawer();
                                          },
                                          onTapDown: (position) {
                                            _getTapPosition(position);
                                          },
                                          child: ListTile(
                                            selected: selectedIndex == index,
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = index;
                                                Provider.of<QuickPayment>(
                                                        context,
                                                        listen: false)
                                                    .setDisplayQuickPayment(
                                                        false);
                                                Provider.of<QuickPayment>(
                                                        context,
                                                        listen: false)
                                                    .setDisplayQuickPaymentSubmit(
                                                        false);
                                              });
                                            },
                                            onLongPress: () {
                                              selectedIndex = index;
                                              data.isSelected = true;
                                              date = DateTime.now();
                                              customerSource
                                                  .setSelectedCustomer(data);
                                              setState(() {
                                                Provider.of<QuickPayment>(
                                                        context,
                                                        listen: false)
                                                    .setDisplayQuickPayment(
                                                        true);
                                                _displayQuickPayment = true;
                                              });
                                            },
                                            selectedTileColor: Colors.black12,
                                            leading:
                                                Builder(builder: (context) {
                                             data.generateLink();
                                              return ClipOval(
                                                  child: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Image.network(
                                                              data.picLink,
                                                              errorBuilder:
                                                                  (context,
                                                                      obect,
                                                                      stack) {
                                                              return Image.asset(
                                                                  _conn.assetProfileImage);
                                                            },
                                                              fit:
                                                                  BoxFit.cover),
                                                      Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              data.customer_id),
                                                        ),
                                                      ),
                                                    ]),
                                              ));
                                            }),
                                            title: Text(data.first_name),
                                            subtitle: Text(data.last_name),
                                          )));
                                }),
                          )),
                    );
                  })),
            ],
          ),
        ),
        _displayQuickPayment ? QuickPaymentWidget() : SizedBox.shrink()
      ]);
    });
  }

  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = (tapPosition.globalPosition);
    });
  }

  void _onDismissed(CustomerRowData data, int index, Actions actions) {
    if (actions == Actions.edit) {
      Navigator.push(context, _buildRoute());
    }
    if (actions == Actions.delete) {
      _conn.deleteByUserID(data.customer_id);
      _conn.deleteProfilePic(data);

    }
  }

  Route _buildRoute() {
    return PageRouteBuilder(
        //  settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            CustomerChangeForm(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset(0.0, 0.0);
          var curve = Curves.elasticInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }
}
