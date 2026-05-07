class OfferModel {
  final String id;
  final String title;
  final String description;
  final double discountPercentage;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final String imageUrl;

  const OfferModel({
    required this.id,
    required this.title,
    this.description = '',
    this.discountPercentage = 0.0,
    this.isActive = true,
    this.startDate,
    this.endDate,
    this.imageUrl = '',
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      discountPercentage: (json['discount_percentage'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date'] as String) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date'] as String) : null,
      imageUrl: json['image_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'discount_percentage': discountPercentage,
        'is_active': isActive,
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'image_url': imageUrl,
      };
}
