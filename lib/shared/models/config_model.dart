class ConfigEntry {
  final String key;
  final String value;
  final DateTime? updatedAt;

  const ConfigEntry({
    required this.key,
    required this.value,
    this.updatedAt,
  });

  factory ConfigEntry.fromJson(Map<String, dynamic> json) {
    return ConfigEntry(
      key: json['key'] as String,
      value: json['value'] as String,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
        'updated_at': updatedAt?.toIso8601String(),
      };
}

/// Parsed, typed representation of all dynamic config keys.
class AppConfig {
  final String instapayNumber;
  final String instapayLink;
  final String paymentInstructions;
  final String serviceRadius;
  final String workingHours;

  const AppConfig({
    this.instapayNumber = '',
    this.instapayLink = '',
    this.paymentInstructions = '',
    this.serviceRadius = '20',
    this.workingHours = '08:00-22:00',
  });

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

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      instapayNumber: json['instapayNumber'] as String? ?? '',
      instapayLink: json['instapayLink'] as String? ?? '',
      paymentInstructions: json['paymentInstructions'] as String? ?? '',
      serviceRadius: json['serviceRadius'] as String? ?? '20',
      workingHours: json['workingHours'] as String? ?? '08:00-22:00',
    );
  }

  Map<String, dynamic> toJson() => {
        'instapayNumber': instapayNumber,
        'instapayLink': instapayLink,
        'paymentInstructions': paymentInstructions,
        'serviceRadius': serviceRadius,
        'workingHours': workingHours,
      };
}
