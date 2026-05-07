class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final String imageUrl;
  final bool isActive;
  final int sortOrder;

  const ServiceModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.durationMinutes = 30,
    this.imageUrl = '',
    this.isActive = true,
    this.sortOrder = 0,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      durationMinutes: json['duration_minutes'] as int? ?? 30,
      imageUrl: json['image_url'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'duration_minutes': durationMinutes,
        'image_url': imageUrl,
        'is_active': isActive,
        'sort_order': sortOrder,
      };
}
