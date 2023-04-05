import 'package:ateam_accounting_12/Forms/CustomerChangeForm.dart';
import 'package:ateam_accounting_12/Forms/PaymentChangeForm.dart';
import 'package:ateam_accounting_12/Models/CameraProv.dart';
import 'package:ateam_accounting_12/Models/CustomerData.dart';
import 'package:ateam_accounting_12/Models/InstructorData.dart';
import 'package:ateam_accounting_12/Models/PaymentData.dart';
import 'package:ateam_accounting_12/Models/QuickPayment.dart';
import 'package:ateam_accounting_12/Pages/CustomerTablePage.dart';
import 'package:ateam_accounting_12/Pages/PaymentTablePage.dart';
import 'package:ateam_accounting_12/Pages/TestPage.dart';
import 'package:ateam_accounting_12/Widgets/AddNewUserForm.dart';
import 'package:ateam_accounting_12/Widgets/ConnectionAlerts.dart';
import 'package:ateam_accounting_12/Widgets/DrawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
//import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CustomerData()),
    ChangeNotifierProvider(create: (context) => PaymentData()),
    ChangeNotifierProvider(create: (context) => QuickPayment()),
    ChangeNotifierProvider(create: (context) => InstructorData()),
    ChangeNotifierProvider(create: (context) => CameraProv())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<InternetConnectionStatus>(
      initialData: InternetConnectionStatus.connected,
      create: (_) {
        return InternetConnectionChecker().onStatusChange;
      },
      child: MaterialApp(
        title: 'Ateam Accounting',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(title: 'Accounting'),
          '/PaymentChangeForm': (context) => PaymentChangeForm(),
          '/CustomerChangeForm': (context) => CustomerChangeForm(),
          '/PaymentsPage': (context) => PaymentTablePage(),
          '/AddNewUserForm': (context) => AddNewUserForm(),
          '/DrawerWidget': (context) => DrawerWidget(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//PaymentData paymentSource = PaymentData();

class _MyHomePageState extends State<MyHomePage> {
  bool shouldLoad = true;

  //ScrollController paymentScroller = ScrollController();
  //var paymentSource = PaymentData();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (Provider
        .of<PaymentData>(context, listen: false)
        .paymentDataRowList
        .length ==
        0) {
      Provider.of<PaymentData>(context, listen: false).getNextPage();
    }
    if (Provider
        .of<CustomerData>(context, listen: false)
        .customerDataRowList
        .length ==
        0) {
      Provider.of<CustomerData>(context, listen: false).getNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [

          DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.account_circle),
                    ),
                    Tab(
                      icon: Icon(Icons.payment),
                    ),
                    Tab(
                      icon: Icon(Icons.nat_sharp),
                    )
                  ],
                ),
                title: Text(widget.title),
              ),
              body: TabBarView(
                children: [
                  CustomerTablePage(),
                  PaymentTablePage(),
                  TestPage(),
                ],
              ),
              //floatingActionButton: FloatingActionButton(
            ),
          ),
          ConnectionAlerts(),
        ]
    );
  }


  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.of(context).push(_buildRoute());
    }
  }

  Route _buildRoute() {
    return PageRouteBuilder(
      //  settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            PaymentTablePage(),
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
