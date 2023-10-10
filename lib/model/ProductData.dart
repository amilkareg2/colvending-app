class ProductData {
  final int countValues;
  final String machineId;
  final String productName;

  ProductData({
    required this.countValues,
    required this.machineId,
    required this.productName,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      countValues: json['count_values'],
      machineId: json['machine_id'],
      productName: json['product_name'],
    );
  }

  static List<ProductData> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ProductData.fromJson(json)).toList();
  }
}
