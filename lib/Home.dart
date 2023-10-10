// ignore_for_file: empty_constructor_bodies

import 'package:flutter/material.dart';
import 'package:namer_app/components/home/CardWidget.dart';
import 'package:namer_app/components/home/CardWidgetInt.dart';
import 'package:namer_app/components/home/ListCardWidget.dart';
import 'package:namer_app/controler.dart';
import 'package:namer_app/model/HomeMachinesMetrics.dart';
import 'package:namer_app/model/HomeMetrics.dart';

class Home extends StatefulWidget {
  final String user;
  final String password;

  Home(this.user, this.password);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<HomeMetrics> metrics;
  late Future<List<HomeMachinesMetrics>> machinesMetrics;

  @override
  void initState() {
    super.initState();
    metrics = fetchHomeMetrics(widget.user, widget.password);
    machinesMetrics = fetchHomeMachinesMetrics(widget.user, widget.password);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height / 3, // Set the height
            child: Container(
              color: Colors.green[100],
              padding: EdgeInsets.all(10),
              child: FutureBuilder<HomeMetrics>(
                  future: metrics,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return HeadCards(snapshot.data!);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return Center(child: const CircularProgressIndicator());
                  }),
            )),

        // Second Section (2/3 of the screen)
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.green[50],
            child: FutureBuilder<List<HomeMachinesMetrics>>(
                future: machinesMetrics,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                        children: snapshot.data!.map((machineData) {
                      return ListCardWidget(machineData);
                    }).toList());
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return Center(child: const CircularProgressIndicator());
                }),
          ),
        ),
      ],
    );
  }
}

class HeadCards extends StatelessWidget {
  final HomeMetrics metrics;

  HeadCards(this.metrics);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      children: [
        CardWidget("Ventas Mesuales", metrics.monthlySale),
        CardWidget("Ventas de hoy", metrics.todaysSale),
        CardWidget("Ventas semanales", metrics.weeklySale),
        CardWidgetInt("Maquinas online", metrics.onlineMachines),
      ],
    );
  }
}

class HeadCardsEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      children: [
        Card(child: CircularProgressIndicator()),
        Card(child: CircularProgressIndicator()),
        Card(child: CircularProgressIndicator()),
      ],
    );
  }
}
