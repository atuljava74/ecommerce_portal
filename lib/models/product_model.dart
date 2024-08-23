class Product {
  final int id;  // Ensure this is an int
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> imageUrls;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.imageUrls,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()), // Convert id to int if it's coming as a string
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()), // Ensure price is a double
      imageUrl: json['image_url'],
      imageUrls: json['image_urls'].split(','),
    );
  }
}
