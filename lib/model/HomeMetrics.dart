class HomeMetrics {
  final double monthlySale;
  final int onlineMachines;
  final double todaysSale;
  final double weeklySale;
  final double yesterdaySale;

  HomeMetrics({
    required this.monthlySale,
    required this.onlineMachines,
    required this.todaysSale,
    required this.weeklySale,
    required this.yesterdaySale,
  });

  factory HomeMetrics.fromJson(Map<String, dynamic> json) {
    return HomeMetrics(
      monthlySale: double.parse(json['monthly_sale']),
      onlineMachines: int.parse(json['online_machines']),
      todaysSale: double.parse(json['todays_sale']),
      weeklySale: double.parse(json['weekly_sale']),
      yesterdaySale: double.parse(json['yesterday_sale']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'monthly_sale': monthlySale.toStringAsFixed(2),
      'online_machines': onlineMachines,
      'todays_sale': todaysSale.toStringAsFixed(2),
      'weekly_sale': weeklySale.toStringAsFixed(2),
      'yesterday_sale': yesterdaySale.toStringAsFixed(2),
    };
  }
}
