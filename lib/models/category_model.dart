class Category {
  final String id;
  final String name;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  // Factory constructor to create a Category from JSON data
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(), // Convert to string in case the ID is an integer
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}
