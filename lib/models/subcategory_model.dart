class Subcategory {
  final String id;
  final String name;
  final String imageUrl;

  Subcategory({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'].toString(),
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}
