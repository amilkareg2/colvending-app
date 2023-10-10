import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:namer_app/controler.dart';
import 'package:namer_app/model/Alarms.dart';
import 'package:namer_app/model/Machine.dart';
import 'package:flutter/services.dart';

class AlarmsTab extends StatefulWidget {
  final List<Machine> machineData;
  final String user;
  final String password;

  AlarmsTab(this.machineData, this.user, this.password);

  @override
  _AlarmsTabState createState() => _AlarmsTabState();
}

class _AlarmsTabState extends State<AlarmsTab> {
  late Future<User> data;

  @override
  void initState() {
    super.initState();
    data = fetchAlarms(widget.user, widget.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final a = await data;
            await setAlarms(widget.user, widget.password, a);
            Fluttertoast.showToast(
              msg: "Accion Completada!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
            );
          },
          child: Icon(Icons.save),
        ),
        body: FutureBuilder<User>(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final TextEditingController _textEditingController =
                    TextEditingController(text: snapshot.data!.email);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      child: TextField(
                          controller: _textEditingController,
                          onChanged: (value) => {snapshot.data!.email = value},
                          decoration: InputDecoration(labelText: 'email'),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.machines.length,
                        itemBuilder: (context, index) {
                          List<Machine> a = widget.machineData
                              .where((element) =>
                                  element.mId ==
                                  snapshot.data!.machines[index].machineId)
                              .toList();
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                          a.isNotEmpty ? a.first.miAlias : ":(",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Ventana de Alarma'),
                                      initialValue: snapshot
                                          .data!.machines[index].freq
                                          .toString(),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value != "") {
                                            snapshot.data!.machines[index]
                                                .freq = int.parse(value);
                                          }
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter
                                            .digitsOnly, // Only allow digits
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Switch(
                                    value:
                                        snapshot.data!.machines[index].power ==
                                            1,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value) {
                                          snapshot.data!.machines[index].power =
                                              1;
                                        } else {
                                          snapshot.data!.machines[index].power =
                                              0;
                                        }
                                      });
                                    },
                                    activeColor: Colors.green,
                                    inactiveThumbColor: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Center(child: const CircularProgressIndicator());
            }));
  }
}
