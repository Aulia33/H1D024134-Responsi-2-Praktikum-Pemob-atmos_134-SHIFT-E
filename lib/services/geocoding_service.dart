import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../models/location_model.dart';

class GeocodingService {
  final http.Client _client;

  GeocodingService({http.Client? client}) : _client = client ?? http.Client();

  /// Searches locations by city name via Open-Meteo Geocoding REST API (HTTP GET)
  Future<List<LocationModel>> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final uri = Uri.parse(
      '${AppConstants.geocodingBaseUrl}?name=${Uri.encodeComponent(trimmed)}&count=10&language=id&format=json',
    );

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('results') && data['results'] is List) {
          final List results = data['results'];
          return results.map((item) => LocationModel.fromJson(item)).toList();
        }
        return [];
      } else {
        throw Exception(
          'Gagal mencari lokasi. Kode status server: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi saat mencari kota: $e');
    }
  }
}
