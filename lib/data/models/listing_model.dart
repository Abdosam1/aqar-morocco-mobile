class ListingModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String? propertyType;
  final String? city;
  final int? bedrooms;
  final int? bathrooms;
  final double? area;
  final List<String> images;
  final DateTime createdAt;
  final bool isFavorited;

  ListingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.propertyType,
    this.city,
    this.bedrooms,
    this.bathrooms,
    this.area,
    required this.images,
    required this.createdAt,
    this.isFavorited = false,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      propertyType: json['property_type']?['name_fr'],
      city: json['city']?['name_fr'],
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      area: (json['area'] as num?)?.toDouble(),
      images: (json['images'] as List?)?.map((i) => i['url'] as String).toList() ?? [],
      createdAt: DateTime.parse(json['created_at']),
      isFavorited: json['is_favorited'] ?? false,
    );
  }
}
