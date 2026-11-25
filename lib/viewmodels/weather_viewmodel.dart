import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService;
  final StorageService _storageService;

  WeatherViewModel({
    WeatherService? weatherService,
    StorageService? storageService,
  })  : _weatherService = weatherService ?? WeatherService(),
        _storageService = storageService ?? StorageService();

  LocationModel? _currentLocation;
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isFavorite = false;

  LocationModel? get currentLocation => _currentLocation;
  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isFavorite => _isFavorite;
  bool get hasData => _weather != null;

  /// Initializes weather data on app start (reads last selected location or default)
  Future<void> initialize() async {
    final lastLoc = await _storageService.getLastLocation();
    await fetchWeatherForLocation(lastLoc);
  }

  /// Fetches weather for a specific location
  Future<void> fetchWeatherForLocation(LocationModel location) async {
    _isLoading = true;
    _errorMessage = null;
    _currentLocation = location;
    notifyListeners();

    try {
      final data = await _weatherService.getWeather(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      _weather = data;
      _isLoading = false;
      _errorMessage = null;

      // Update favorite status & save as last visited location
      _isFavorite = await _storageService.isFavorite(location);
      await _storageService.saveLastLocation(location);
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    notifyListeners();
  }

  /// Pull-to-refresh weather for the currently active location
  Future<void> refreshWeather() async {
    if (_currentLocation == null) return;
    try {
      final data = await _weatherService.getWeather(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
      );
      _weather = data;
      _errorMessage = null;
      _isFavorite = await _storageService.isFavorite(_currentLocation!);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }

  /// Toggle favorite from the Home screen
  Future<void> toggleCurrentLocationFavorite() async {
    if (_currentLocation == null) return;

    if (_isFavorite) {
      await _storageService.removeFavorite(_currentLocation!);
      _isFavorite = false;
    } else {
      await _storageService.addFavorite(_currentLocation!);
      _isFavorite = true;
    }
    notifyListeners();
  }
}
