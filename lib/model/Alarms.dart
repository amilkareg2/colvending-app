class User {
  String email;
  final List<MachineAlarm> machines;

  User({
    required this.email,
    required this.machines,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final List<dynamic> machinesJson = json['machines'];
    List<MachineAlarm> machines = machinesJson
        .map((machineJson) => MachineAlarm.fromJson(machineJson))
        .toList();

    return User(
      email: json['email'],
      machines: machines,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'machines': machines.map((machine) => machine.toJson()).toList(),
    };
  }
}

class MachineAlarm {
  int freq;
  final String machineId;
  int power;

  MachineAlarm({
    required this.freq,
    required this.machineId,
    required this.power,
  });

  factory MachineAlarm.fromJson(Map<String, dynamic> json) {
    return MachineAlarm(
      freq: json['freq'],
      machineId: json['machine_id'],
      power: (json['power'] as int), // Mapping to double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'freq': freq,
      'machine_id': machineId,
      'power': power,
    };
  }
}
