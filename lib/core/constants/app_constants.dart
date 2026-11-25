class AppConstants {
  static const String appName = 'Atmos';
  static const String projectName = 'Atmos_134';
  static const String appTagline = 'Feel the sky. Know the weather.';
  static const String appVersion = '1.0.0';

  // Default initial city: Purwokerto (home of UNSOED)
  static const String defaultCityName = 'Kota Purwokerto';
  static const String defaultCountry = 'Indonesia';
  static const String defaultAdmin1 = 'Jawa Tengah';
  static const double defaultLatitude = -7.42139;
  static const double defaultLongitude = 109.23444;

  // Open-Meteo Endpoints
  static const String weatherForecastBaseUrl =
      'https://api.open-meteo.com/v1/forecast';
  static const String geocodingBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  // Local Storage Keys
  static const String keyFavorites = 'atmos_favorite_locations';
  static const String keyRecentSearches = 'atmos_recent_searches';
  static const String keyLastLocation = 'atmos_last_selected_location';
}
