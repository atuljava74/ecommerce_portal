class Order {
  final int id;
  final double total;
  final String date;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.total,
    required this.date,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      total: double.parse(json['total'].toString()),
      date: json['date'],
      items: (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList(),
    );
  }
}

class OrderItem {
  final int id;
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
    );
  }
}
