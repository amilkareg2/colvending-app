import 'package:flutter/material.dart';
import 'package:namer_app/Homepage.dart';
import 'package:namer_app/loggin.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<SharedPreferences> prefs;

  @override
  void initState() {
    super.initState();
    prefs = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Colvending, a tu alcance',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder<SharedPreferences>(
            future: prefs,
            builder: (context, snapshot2) {
              if (snapshot2.hasData) {
                return snapshot2.data!.getString("user") != null
                    ? MyHomePage(
                        snapshot2.data!,
                        snapshot2.data!.getString("user")!,
                        snapshot2.data!.getString("password")!)
                    : LoginScreen(snapshot2.data!);
              } else if (snapshot2.hasError) {
                return Text('${snapshot2.error}');
              }
              return Center(child: const CircularProgressIndicator());
            }));
  }
}
