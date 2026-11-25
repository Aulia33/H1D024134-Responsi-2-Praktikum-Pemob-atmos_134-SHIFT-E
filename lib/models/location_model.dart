class LocationModel {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String country;
  final String admin1;
  bool isFavorite;

  LocationModel({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.admin1,
    this.isFavorite = false,
  });

  /// Location subtitle: e.g. "Jawa Tengah, Indonesia" or just country
  String get subtitle {
    if (admin1.isNotEmpty && country.isNotEmpty) {
      return '$admin1, $country';
    } else if (admin1.isNotEmpty) {
      return admin1;
    }
    return country;
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] is int ? json['id'] : null,
      name: json['name'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      country: json['country'] ?? '',
      admin1: json['admin1'] ?? '',
      isFavorite: json['isFavorite'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
      'isFavorite': isFavorite,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationModel &&
        ((other.id != null && id != null && other.id == id) ||
            (other.name.toLowerCase() == name.toLowerCase() &&
                (other.latitude - latitude).abs() < 0.01 &&
                (other.longitude - longitude).abs() < 0.01));
  }

  @override
  int get hashCode => name.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
