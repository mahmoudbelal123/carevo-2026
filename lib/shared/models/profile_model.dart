import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

enum UserRole {
  @JsonValue('customer') customer,
  @JsonValue('admin') admin,
  @JsonValue('washer') washer,
}

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    @Default('') String fullName,
    @Default('') String phone,
    @Default(UserRole.customer) UserRole role,
    required DateTime createdAt,
  }) = _ProfileModel;

  const ProfileModel._();

  bool get isAdmin => role == UserRole.admin;
  bool get isWasher => role == UserRole.washer;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
