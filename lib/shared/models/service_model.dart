import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

@freezed
class ServiceModel with _$ServiceModel {
  const factory ServiceModel({
    required String id,
    required String name,
    @Default('') String description,
    required double price,
    @Default(30) int durationMinutes,
    @Default('') String imageUrl,
    @Default(true) bool isActive,
    @Default(0) int sortOrder,
  }) = _ServiceModel;

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);
}
