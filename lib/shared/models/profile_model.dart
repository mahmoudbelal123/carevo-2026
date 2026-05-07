import 'package:json_annotation/json_annotation.dart';

enum UserRole {
  @JsonValue('customer')
  customer,
  @JsonValue('admin')
  admin,
  @JsonValue('washer')
  washer,
}

class ProfileModel {
  final String id;
  final String fullName;
  final String phone;
  final UserRole role;
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    this.fullName = '',
    this.phone = '',
    this.role = UserRole.customer,
    required this.createdAt,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isWasher => role == UserRole.washer;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: _parseUserRole(json['role'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static UserRole _parseUserRole(String? role) {
    if (role == null) return UserRole.customer;
    return UserRole.values.firstWhere(
      (e) => e.name == role || e.toString().split('.').last == role,
      orElse: () => UserRole.customer,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'phone': phone,
        'role': role.name,
        'created_at': createdAt.toIso8601String(),
      };
}
