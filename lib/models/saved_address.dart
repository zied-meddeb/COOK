class SavedAddress {
  final String id;
  final String label; // "Maison", "Bureau", etc.
  final String address;
  final String? additionalInfo;
  final double latitude;
  final double longitude;
  final bool isDefault;
  final DateTime createdAt;

  const SavedAddress({
    required this.id,
    required this.label,
    required this.address,
    this.additionalInfo,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
    required this.createdAt,
  });

  SavedAddress copyWith({
    String? id,
    String? label,
    String? address,
    String? additionalInfo,
    double? latitude,
    double? longitude,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return SavedAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      address: address ?? this.address,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'address': address,
      'additionalInfo': additionalInfo,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SavedAddress.fromJson(Map<String, dynamic> json) {
    return SavedAddress(
      id: json['id'],
      label: json['label'],
      address: json['address'],
      additionalInfo: json['additionalInfo'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  String toString() {
    return 'SavedAddress(id: $id, label: $label, address: $address)';
  }
}

