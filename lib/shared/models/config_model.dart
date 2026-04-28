import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_model.freezed.dart';
part 'config_model.g.dart';

@freezed
class ConfigEntry with _$ConfigEntry {
  const factory ConfigEntry({
    required String key,
    required String value,
    DateTime? updatedAt,
  }) = _ConfigEntry;

  factory ConfigEntry.fromJson(Map<String, dynamic> json) =>
      _$ConfigEntryFromJson(json);
}

/// Parsed, typed representation of all dynamic config keys.
@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    @Default('') String instapayNumber,
    @Default('') String instapayLink,
    @Default('') String paymentInstructions,
    @Default('20') String serviceRadius,
    @Default('08:00-22:00') String workingHours,
  }) = _AppConfig;

  factory AppConfig.fromEntries(List<ConfigEntry> entries) {
    final map = {for (final e in entries) e.key: e.value};
    return AppConfig(
      instapayNumber: map['instapay_number'] ?? '',
      instapayLink: map['instapay_link'] ?? '',
      paymentInstructions: map['payment_instructions'] ?? '',
      serviceRadius: map['service_radius'] ?? '20',
      workingHours: map['working_hours'] ?? '08:00-22:00',
    );
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);
}
