import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/location_model.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Get list of favorite locations from local storage
  Future<List<LocationModel>> getFavorites() async {
    final prefs = await _getPrefs();
    final List<String>? jsonList = prefs.getStringList(AppConstants.keyFavorites);
    if (jsonList == null || jsonList.isEmpty) return [];

    try {
      return jsonList
          .map((item) => LocationModel.fromJson(json.decode(item)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Save or update favorite locations
  Future<bool> saveFavorites(List<LocationModel> favorites) async {
    final prefs = await _getPrefs();
    final List<String> jsonList =
        favorites.map((loc) => json.encode(loc.toJson())).toList();
    return await prefs.setStringList(AppConstants.keyFavorites, jsonList);
  }

  /// Add a location to favorites
  Future<List<LocationModel>> addFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    location.isFavorite = true;
    if (!favorites.contains(location)) {
      favorites.add(location);
      await saveFavorites(favorites);
    }
    return favorites;
  }

  /// Remove a location from favorites
  Future<List<LocationModel>> removeFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    favorites.removeWhere((item) => item == location);
    await saveFavorites(favorites);
    return favorites;
  }

  /// Check if a location is currently in favorites
  Future<bool> isFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    return favorites.contains(location);
  }

  /// Save last viewed location
  Future<bool> saveLastLocation(LocationModel location) async {
    final prefs = await _getPrefs();
    return await prefs.setString(
      AppConstants.keyLastLocation,
      json.encode(location.toJson()),
    );
  }

  /// Get last viewed location (defaults to Purwokerto if not set)
  Future<LocationModel> getLastLocation() async {
    final prefs = await _getPrefs();
    final String? jsonStr = prefs.getString(AppConstants.keyLastLocation);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        return LocationModel.fromJson(json.decode(jsonStr));
      } catch (_) {}
    }

    // Default: Kota Purwokerto
    return LocationModel(
      name: AppConstants.defaultCityName,
      latitude: AppConstants.defaultLatitude,
      longitude: AppConstants.defaultLongitude,
      country: AppConstants.defaultCountry,
      admin1: AppConstants.defaultAdmin1,
    );
  }

  /// Get search history
  Future<List<String>> getRecentSearches() async {
    final prefs = await _getPrefs();
    return prefs.getStringList(AppConstants.keyRecentSearches) ?? [];
  }

  /// Add a query to recent searches
  Future<void> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final prefs = await _getPrefs();
    final list = prefs.getStringList(AppConstants.keyRecentSearches) ?? [];
    list.remove(trimmed);
    list.insert(0, trimmed);
    if (list.length > 8) {
      list.removeLast();
    }
    await prefs.setStringList(AppConstants.keyRecentSearches, list);
  }

  /// Clear recent searches
  Future<void> clearRecentSearches() async {
    final prefs = await _getPrefs();
    await prefs.remove(AppConstants.keyRecentSearches);
  }
}
