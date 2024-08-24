class CartItem {
  final int id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final double subtotal;
  final int productId;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.subtotal,
    required this.productId
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      quantity: json['quantity'],
      imageUrl: json['image_url'],
      subtotal: double.parse(json['subtotal'].toString()),
      productId: json['product_id'],
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
      'productId' : productId
    };
  }
}
