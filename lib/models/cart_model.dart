class CartItem {
  final int id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final double subtotal;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.subtotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      quantity: json['quantity'],
      imageUrl: json['image_url'],
      subtotal: double.parse(json['subtotal'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
      'subtotal': subtotal,
    };
  }
}
