import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/location_model.dart';
import '../../viewmodels/location_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';

class SearchScreen extends StatefulWidget {
  final Function(LocationModel location)? onLocationSelected;
  final VoidCallback? onBack;

  const SearchScreen({
    super.key,
    this.onLocationSelected,
    this.onBack,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationViewModel>(context, listen: false).loadInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onCitySelected(LocationModel location) {
    // 1. Ambil data cuaca kota yang dipilih secara langsung
    final weatherVM = Provider.of<WeatherViewModel>(context, listen: false);
    weatherVM.fetchWeatherForLocation(location);

    // 2. Panggil callback jika dibuka dari tab bar untuk kembali ke tab Today
    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(location);
    }

    // 3. Hanya lakukan pop jika screen ini dibuka menggunakan Navigator.push
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationViewModel>(
      builder: (context, locationVM, child) {
        final favorites = locationVM.favorites;
        final recentSearches = locationVM.recentSearches;
        final searchResults = locationVM.searchResults;
        final isSearching = locationVM.isSearching;
        final query = locationVM.currentQuery;

        return Scaffold(
          backgroundColor: AppTheme.neutralBg,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: (Navigator.of(context).canPop() || widget.onBack != null)
                ? IconButton(
                    icon: const Icon(CupertinoIcons.back, color: Colors.white),
                    onPressed: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                  )
                : null,
            title: const Text(
              'Cari Lokasi & Cuaca',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Search Input Field
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.cardBorder,
                      width: 1.2,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ketik nama kota (misal: Jakarta, Bandung)...',
                      hintStyle: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        CupertinoIcons.search,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                CupertinoIcons.clear_circled_solid,
                                color: AppTheme.textMuted,
                                size: 18,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                locationVM.clearSearch();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: (value) {
                      locationVM.searchCities(value);
                    },
                    onChanged: (value) {
                      if (value.trim().length >= 3) {
                        locationVM.searchCities(value);
                      } else if (value.trim().isEmpty) {
                        locationVM.clearSearch();
                      }
                    },
                  ),
                ),
              ),

              // Main Body Content
              Expanded(
                child: isSearching
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppTheme.primary,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Mencari kota di Open-Meteo...',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : locationVM.errorMessage != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    CupertinoIcons.exclamationmark_circle,
                                    size: 48,
                                    color: AppTheme.secondary,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    locationVM.errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primary,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () => locationVM.searchCities(
                                      _searchController.text,
                                    ),
                                    child: const Text('Ulangi Pencarian'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : query.isNotEmpty
                            ? _buildSearchResults(searchResults, locationVM)
                            : _buildFavoritesAndHistory(
                                favorites,
                                recentSearches,
                                locationVM,
                              ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds active search results list
  Widget _buildSearchResults(
    List<LocationModel> results,
    LocationViewModel locationVM,
  ) {
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.search,
                size: 64,
                color: AppTheme.cardBorder,
              ),
              const SizedBox(height: 16),
              const Text(
                'Kota Tidak Ditemukan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Periksa kembali ejaan nama kota atau gunakan nama kota yang lebih umum.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        final isFav = locationVM.isLocationFavorite(item);

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          color: AppTheme.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppTheme.cardBorder),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 6,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.location_solid,
                color: AppTheme.primary,
                size: 18,
              ),
            ),
            title: Text(
              item.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              item.subtitle,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                color: isFav ? AppTheme.primary : AppTheme.textMuted,
                size: 22,
              ),
              onPressed: () {
                locationVM.toggleFavorite(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFav
                          ? '${item.name} dihapus dari Favorit'
                          : '${item.name} disimpan ke Favorit',
                    ),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            onTap: () => _onCitySelected(item),
          ),
        );
      },
    );
  }

  /// Builds favorites list and recent searches when search is not active
  Widget _buildFavoritesAndHistory(
    List<LocationModel> favorites,
    List<String> recentSearches,
    LocationViewModel locationVM,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      children: [
        // 1. KOTA FAVORIT SECTION
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(
                  CupertinoIcons.heart_fill,
                  size: 16,
                  color: AppTheme.primary,
                ),
                SizedBox(width: 8),
                Text(
                  'Lokasi Favorit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Text(
              '${favorites.length} kota',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (favorites.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: const Row(
              children: [
                Icon(
                  CupertinoIcons.heart,
                  color: AppTheme.textMuted,
                  size: 24,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Belum ada lokasi favorit. Cari kota dan tekan ikon hati untuk menyimpannya.',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            itemCount: favorites.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final fav = favorites[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                color: AppTheme.cardSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: const BorderSide(color: AppTheme.cardBorder),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.location_solid,
                      color: AppTheme.primary,
                      size: 16,
                    ),
                  ),
                  title: Text(
                    fav.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    fav.subtitle,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      CupertinoIcons.heart_fill,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                    onPressed: () {
                      locationVM.toggleFavorite(fav);
                    },
                    tooltip: 'Hapus Favorit',
                  ),
                  onTap: () => _onCitySelected(fav),
                ),
              );
            },
          ),

        const SizedBox(height: 24),

        // 2. RIWAYAT PENCARIAN SECTION
        if (recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    CupertinoIcons.time,
                    size: 16,
                    color: AppTheme.secondary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Riwayat Pencarian',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => locationVM.clearRecentSearches(),
                child: const Text(
                  'Hapus Semua',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recentSearches.map((term) {
              return ActionChip(
                backgroundColor: AppTheme.cardSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppTheme.cardBorder),
                ),
                avatar: const Icon(
                  CupertinoIcons.search,
                  size: 13,
                  color: AppTheme.secondary,
                ),
                label: Text(
                  term,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  _searchController.text = term;
                  locationVM.searchCities(term);
                },
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: 28),

        // 3. KOTA POPULER DI INDONESIA
        const Text(
          'Kota Populer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            LocationModel(
              name: 'Purwokerto',
              latitude: -7.42139,
              longitude: 109.23444,
              country: 'Indonesia',
              admin1: 'Jawa Tengah',
            ),
            LocationModel(
              name: 'Jakarta',
              latitude: -6.2088,
              longitude: 106.8456,
              country: 'Indonesia',
              admin1: 'DKI Jakarta',
            ),
            LocationModel(
              name: 'Bandung',
              latitude: -6.9175,
              longitude: 107.6191,
              country: 'Indonesia',
              admin1: 'Jawa Barat',
            ),
            LocationModel(
              name: 'Surabaya',
              latitude: -7.2575,
              longitude: 112.7521,
              country: 'Indonesia',
              admin1: 'Jawa Timur',
            ),
            LocationModel(
              name: 'Yogyakarta',
              latitude: -7.7956,
              longitude: 110.3695,
              country: 'Indonesia',
              admin1: 'DI Yogyakarta',
            ),
            LocationModel(
              name: 'Denpasar',
              latitude: -8.6705,
              longitude: 115.2126,
              country: 'Indonesia',
              admin1: 'Bali',
            ),
          ].map((city) {
            return ActionChip(
              backgroundColor: AppTheme.cardSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.cardBorder),
              ),
              avatar: const Icon(
                CupertinoIcons.placemark_fill,
                size: 13,
                color: AppTheme.primary,
              ),
              label: Text(
                city.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () => _onCitySelected(city),
            );
          }).toList(),
        ),
      ],
    );
  }
}
