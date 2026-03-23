enum ListingType { sale, rent }

class ListingModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final ListingType? listingType; // sale or rent enum
  final String? propertyType;
  final String? city;
  final int? bedrooms;
  final int? bathrooms;
  final double? areaM2;
  final List<String> images;
  final DateTime createdAt;
  final bool isFavorited;
  final String? phoneContact;
  final String? whatsappContact;
  final bool isVerified;
  final bool userVerified;

  ListingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.listingType,
    this.propertyType,
    this.city,
    this.bedrooms,
    this.bathrooms,
    this.areaM2,
    required this.images,
    required this.createdAt,
    this.isFavorited = false,
    this.phoneContact,
    this.whatsappContact,
    this.isVerified = false,
    this.userVerified = false,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    ListingType? lt;
    if (json['listing_type'] == 'sale') lt = ListingType.sale;
    if (json['listing_type'] == 'rent') lt = ListingType.rent;

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ListingModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: parseDouble(json['price']),
      listingType: lt,
      propertyType: json['property_type']?['name_fr'] ?? json['property_type']?['name'],
      city: json['city']?['name_fr'] ?? json['city']?['name'],
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      areaM2: parseDouble(json['area_m2']),
      images: (json['images'] as List?)?.map((i) => i['image_url'] as String).toList() ?? [],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      isFavorited: json['is_favorited'] ?? false,
      phoneContact: json['phone_contact'],
      whatsappContact: json['whatsapp_contact'],
      isVerified: json['status'] == 'approved', // Listings approved by admin are "Verified" or have separate flag
      userVerified: json['user']?['is_verified'] ?? false,
    );
  }
}
