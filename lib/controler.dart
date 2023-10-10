import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:namer_app/model/Alarms.dart';
import 'package:namer_app/model/HomeMachinesMetrics.dart';
import 'package:namer_app/model/HomeMetrics.dart';
import 'package:namer_app/model/Machine.dart';
import 'package:namer_app/model/ProductData.dart';

const Map<String, String> defualt2 = {};

Future<Map<String, dynamic>> fetch(
    String endpoint, String username, String password,
    [Map<String, dynamic> body = defualt2]) async {
  Map<String, String> headers = {'Content-Type': 'application/json'};
  final response = await http.post(
      Uri.parse(
          'https://southamerica-east1-valiant-circuit-398421.cloudfunctions.net/backend/$endpoint'),
      body: jsonEncode({"username": username, "password": password, ...body}),
      headers: headers);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print(response.body);
    throw Exception('Failed to load data');
  }
}

Future<bool> auth(String username, String password) async {
  Map<String, String> headers = {'Content-Type': 'application/json'};
  final response = await http.post(
      Uri.parse(
          'https://southamerica-east1-valiant-circuit-398421.cloudfunctions.net/backend/'),
      body: jsonEncode({"username": username, "password": password}),
      headers: headers);
  return response.statusCode == 200;
}

Future<HomeMetrics> fetchHomeMetrics(String username, String password) async {
  return HomeMetrics.fromJson(
      (await fetch("home", username, password))["response"]);
}

Future<List<HomeMachinesMetrics>> fetchHomeMachinesMetrics(
    String username, String password) async {
  Map<String, dynamic> a = await fetch("daily_sales", username, password);
  return HomeMachinesMetrics.fromJsonList(a["response"]);
}

Future<List<Machine>> fetchMachines(String username, String password) async {
  Map<String, dynamic> a = await fetch("get_metadata", username, password);
  return Machine.fromJsonList(a["response"]);
}

Future<User> fetchAlarms(String username, String password) async {
  Map<String, dynamic> a = await fetch("get_alarm_config", username, password);
  return User.fromJson(a["response"]);
}

Future<void> setAlarms(String username, String password, User user) async {
  Map<String, String> headers = {'Content-Type': 'application/json'};
  final response = await http.post(
      Uri.parse(
          'https://southamerica-east1-valiant-circuit-398421.cloudfunctions.net/backend/edit_alarm_config'),
      body: jsonEncode({
        "username": username,
        "password": password,
        "config": user.toJson()
      }),
      headers: headers);
  response.statusCode == 200;
}

Future<List<ProductData>> _fectPicking(
    String username, String password, List<Machine> machines) async {
  Map<String, dynamic> a = await fetch("picking", username, password, {
    "machines": machines
        .map((machine) => {"group_id": machine.mgId, "machine_id": machine.mId})
        .toList()
  });
  return ProductData.fromJsonList(a["response"]);
}

Future<List<Map<String, dynamic>>> fectPicking(
    String username, String password, List<Machine> machines) async {
  List<ProductData> a = await _fectPicking(username, password, machines);
  Map<String, String> h = {};
  for (Machine g in machines) {
    h[g.mId] = g.miAlias;
  }
  Map<String, List<ProductData>> aux = {};
  for (ProductData b in a) {
    if (!aux.containsKey(b.productName)) {
      aux[b.productName] = [];
    }
    aux[b.productName]!.add(b);
  }
  List<Map<String, dynamic>> j = aux.entries
      .map<Map<String, dynamic>>((e) => {
            "name": e.key,
            "count": e.value
                .map((e) => e.countValues)
                .reduce((value, element) => value + element),
            "sub": e.value.map((e) => {h[e.machineId]!: e.countValues}).toList()
          })
      .toList();
  j.sort((a, b) => -a['count'].compareTo(b['count']));
  return j;
}

Future<String> llene(
    String username, String password, List<Machine> machines) async {
  Map<String, String> headers = {'Content-Type': 'application/json'};
  await http.post(
      Uri.parse(
          'https://southamerica-east1-valiant-circuit-398421.cloudfunctions.net/backend/finish_stocking'),
      body: jsonEncode({
        "username": username,
        "password": password,
        "machine_ids": machines.map((e) => e.mId).toList()
      }),
      headers: headers);
  return "ok";
}
