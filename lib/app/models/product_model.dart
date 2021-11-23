class ProductModel {
  int? id;
  String name;
  double price;
  double? discount;
  double? percentage;
  bool isAvailable;
  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.percentage,
    required this.isAvailable,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'discount': discount,
      'percentage': percentage,
      'is_available': isAvailable ? 1 : 0,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
        // ignore: prefer_if_null_operators
        id: map['id'] != null ? map['id'] : null,
        name: map['name'],
        price: map['price'],
        discount: map['discount'],
        percentage: map['percentage'],
        isAvailable: map['is_available'] == 1 ? true : false);
  }
}
