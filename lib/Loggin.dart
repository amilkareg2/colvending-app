import 'package:flutter/material.dart';
import 'package:namer_app/controler.dart';
import 'package:namer_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final SharedPreferences prefs;

  LoginScreen(this.prefs);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Username'),
                onChanged: (value) {
                  // Store the value in a variable or a state variable
                  username = value;
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                onChanged: (value) {
                  // Store the value in a variable or a state variable
                  password = value;
                },
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Add your login logic here
                  if (await auth(username, password)) {
                    widget.prefs.setString('user', username);
                    widget.prefs.setString('password', password);
                    runApp(MyApp());
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
