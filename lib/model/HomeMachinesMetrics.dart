class HomeMachinesMetrics {
  final double cashAmount;
  final int change;
  final int coinAmount;
  final int failAmount;
  final String mId;
  final String mgName;
  final String miAlias;
  final int miInsideTemp;
  final double noteAmount;
  final double saleAmount;
  final double saleQuantity;

  HomeMachinesMetrics({
    required this.cashAmount,
    required this.change,
    required this.coinAmount,
    required this.failAmount,
    required this.mId,
    required this.mgName,
    required this.miAlias,
    required this.miInsideTemp,
    required this.noteAmount,
    required this.saleAmount,
    required this.saleQuantity,
  });

  factory HomeMachinesMetrics.fromJson(Map<String, dynamic> json) {
    return HomeMachinesMetrics(
      cashAmount: double.parse(json['CashAmount'].toString()),
      change: json['Change'],
      coinAmount: json['CoinAmount'],
      failAmount: json['FailAmount'],
      mId: json['MId'],
      mgName: json['MgName'],
      miAlias: json['MiAlias'],
      miInsideTemp: int.parse(json['MiInsideTemp']),
      noteAmount: double.parse(json['NoteAmount'].toString()),
      saleAmount: double.parse(json['SaleAmount'].toString()),
      saleQuantity: double.parse(json['SaleQuantity'].toString()),
    );
  }

  static List<HomeMachinesMetrics> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => HomeMachinesMetrics.fromJson(json)).toList();
  }
}
