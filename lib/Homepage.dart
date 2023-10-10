import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AlarmsTab.dart';
import 'Home.dart';
import 'Picking.dart';
import 'controler.dart';
import 'model/Machine.dart';

class MyHomePage extends StatefulWidget {
  final SharedPreferences prefs;
  final String user;
  final String password;

  MyHomePage(this.prefs, this.user, this.password);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 1;

  late Future<List<Machine>> machines;

  @override
  void initState() {
    super.initState();
    machines = fetchMachines(widget.user, widget.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Colvending, a tu alcance'),
      ),
      body: FutureBuilder<List<Machine>>(
        future: machines,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            {
              switch (_currentIndex) {
                case 0:
                  return Picking(snapshot.data!, widget.user, widget.password);
                case 1:
                  return Home(widget.user, widget.password);
                case 2:
                  return AlarmsTab(
                      snapshot.data!, widget.user, widget.password);
              }
            }
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: const CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Picking ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 50),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Alarmas")
        ],
      ),
    );
  }
}
