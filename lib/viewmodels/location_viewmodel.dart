import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../services/geocoding_service.dart';
import '../services/storage_service.dart';

class LocationViewModel extends ChangeNotifier {
  final GeocodingService _geocodingService;
  final StorageService _storageService;

  LocationViewModel({
    GeocodingService? geocodingService,
    StorageService? storageService,
  })  : _geocodingService = geocodingService ?? GeocodingService(),
        _storageService = storageService ?? StorageService();

  List<LocationModel> _searchResults = [];
  List<LocationModel> _favorites = [];
  List<String> _recentSearches = [];
  bool _isSearching = false;
  String? _errorMessage;
  String _currentQuery = '';

  List<LocationModel> get searchResults => _searchResults;
  List<LocationModel> get favorites => _favorites;
  List<String> get recentSearches => _recentSearches;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  String get currentQuery => _currentQuery;

  /// Loads saved favorites & search history from local storage
  Future<void> loadInitialData() async {
    _favorites = await _storageService.getFavorites();
    _recentSearches = await _storageService.getRecentSearches();
    notifyListeners();
  }

  /// Searches cities from Open-Meteo Geocoding REST API
  Future<void> searchCities(String query) async {
    final trimmed = query.trim();
    _currentQuery = trimmed;

    if (trimmed.isEmpty) {
      _searchResults = [];
      _isSearching = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _geocodingService.searchCities(trimmed);

      // Check each result against favorites
      final favList = await _storageService.getFavorites();
      for (final item in results) {
        item.isFavorite = favList.contains(item);
      }

      _searchResults = results;
      _isSearching = false;
      _errorMessage = null;

      // Save to recent searches if found
      if (results.isNotEmpty) {
        await _storageService.addRecentSearch(trimmed);
        _recentSearches = await _storageService.getRecentSearches();
      }
    } catch (e) {
      _isSearching = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    notifyListeners();
  }

  /// Toggle favorite status of a location
  Future<void> toggleFavorite(LocationModel location) async {
    final isFav = _favorites.contains(location);

    if (isFav) {
      _favorites = await _storageService.removeFavorite(location);
      location.isFavorite = false;
    } else {
      _favorites = await _storageService.addFavorite(location);
      location.isFavorite = true;
    }

    // Synchronize favorite flag in search results
    for (final item in _searchResults) {
      if (item == location) {
        item.isFavorite = !isFav;
      }
    }

    notifyListeners();
  }

  /// Checks if location is in favorites
  bool isLocationFavorite(LocationModel location) {
    return _favorites.contains(location);
  }

  /// Clears recent searches
  Future<void> clearRecentSearches() async {
    await _storageService.clearRecentSearches();
    _recentSearches = [];
    notifyListeners();
  }

  /// Clears search results
  void clearSearch() {
    _currentQuery = '';
    _searchResults = [];
    _errorMessage = null;
    _isSearching = false;
    notifyListeners();
  }
}
