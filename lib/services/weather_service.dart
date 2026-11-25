import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../models/weather_model.dart';

class WeatherService {
  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches real-time weather, hourly forecast, and 7-day outlook from Open-Meteo REST API
  Future<WeatherModel> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      '${AppConstants.weatherForecastBaseUrl}?'
      'latitude=$latitude&'
      'longitude=$longitude&'
      'current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&'
      'hourly=temperature_2m,weather_code,precipitation_probability&'
      'daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&'
      'timezone=auto',
    );

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception(
          'Gagal mengambil data cuaca dari Open-Meteo (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Gagal menghubungi server cuaca Open-Meteo: $e');
    }
  }
}
