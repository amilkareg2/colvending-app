class Machine {
  final String mgId;
  final String mgName;
  final String mId;
  final String miAlias;

  Machine({
    required this.mgId,
    required this.mgName,
    required this.mId,
    required this.miAlias,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      mgId: json['MGID'],
      mgName: json['MGName'],
      mId: json['MId'],
      miAlias: json['MiAlias'],
    );
  }

  static List<Machine> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Machine.fromJson(json)).toList();
  }
}
