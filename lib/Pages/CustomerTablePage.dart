import 'package:ateam_accounting_12/API/DataBaseConn.dart';
import 'package:ateam_accounting_12/DataTable/CustomerTable.dart';
import 'package:ateam_accounting_12/Forms/CustomerChangeForm.dart';
import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:ateam_accounting_12/Widgets/AddNewUserForm.dart';
import 'package:ateam_accounting_12/Widgets/DrawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CustomerTablePage extends StatefulWidget {
  const CustomerTablePage({Key? key}) : super(key: key);

  @override
  State<CustomerTablePage> createState() {
    return _MyCustomerTablePageState();
  }
}

enum Actions { edit, delete, archive }

class _MyCustomerTablePageState extends State<CustomerTablePage> {
  bool shouldLoad = true;
  ScrollController customerScroller = ScrollController();
  DateTime date = DateTime.now();
/*
  var _amountController = TextEditingController();
  String _quickAddPayment = "";
  bool _displayQuickPayment = false;
  final _quickPaymentFormKey = GlobalKey<FormState>();
  bool _displayQuickPaymentSubmit = false;
  String? _quickPaymentAmount;
*/

  int selectedIndex = 0;
  var _conn = DataBaseConn();
  // var _displayConnected = false;
@override
  void initState() {
  super.initState();
  Future.delayed(Duration(milliseconds: 0), () {
    Provider.of<CustomerData>(context, listen: false).uploadImageFile=null;
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/AddNewUserForm");
        },
        tooltip: 'pcf',
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        // elevation: 0,
        //  backgroundColor: Colors.white,
        child: DrawerWidget(),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                opacity: 0.2,
                image: AssetImage(_conn.assetBackgroundImage))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CustomerTable()
              //    ConnectionAlerts(),
            ],
          ),
        ),
      ),
    );
  }

  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
    });
  }

  void _onDismissed(int index, Actions actions) {
    if (actions == Actions.edit) {
      Navigator.push(context, _buildRoute());
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

  void _showAddNewUser() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            elevation: 10,
            backgroundColor: Colors.grey[200],
            content: AddNewUserForm(),
          );
        });
  }
}
