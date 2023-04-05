import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class ConnectionAlerts extends StatefulWidget {
  @override
  State<ConnectionAlerts> createState() {
    return _ConnectionAlertsState();
  }
}

class _ConnectionAlertsState extends State<ConnectionAlerts> {
  bool _displayConnected = false;

  Future<void> _changedisplay() async {
    if (Provider.of<InternetConnectionStatus>(context) ==
        InternetConnectionStatus.connected) {
      await Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _displayConnected = false;
        });
      });
    } else {
      await Future.delayed(Duration(milliseconds: 2000), () {
        setState(() {
          _displayConnected = !_displayConnected;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _changedisplay();
    return Center(
      child: Builder(builder: (context) {
        return (Provider.of<InternetConnectionStatus>(context) ==
                InternetConnectionStatus.disconnected)
            ? AnimatedOpacity(
                opacity: _displayConnected ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                curve: Curves.linear,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi,
                        color: Colors.red,
                        size: 150,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Not connected',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Builder(builder: (context) {
                //  _displayConnected = true;

                return _displayConnected
                    ? Center(
                        child: AnimatedOpacity(
                        duration: Duration(seconds: 2),
                        opacity: _displayConnected ? 1.0 : 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(20)),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Connected',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                          ),
                        ),
                      ))
                    : SizedBox.shrink();
              });
      }),
    );
  }
}
