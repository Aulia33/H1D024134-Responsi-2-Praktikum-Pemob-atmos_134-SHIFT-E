import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/location_model.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/daily_forecast_list.dart';
import 'widgets/hourly_forecast_list.dart';
import 'widgets/weather_metrics_grid.dart';
import 'widgets/weather_overview_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;
  bool _isCelsius = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weatherVM = Provider.of<WeatherViewModel>(context, listen: false);
      if (!weatherVM.hasData && !weatherVM.isLoading) {
        weatherVM.initialize();
      }
    });
  }

  void _openSearchScreen() async {
    final weatherVM = Provider.of<WeatherViewModel>(context, listen: false);
    final selectedLocation = await Navigator.of(context).push<LocationModel>(
      CupertinoPageRoute(
        builder: (context) => const SearchScreen(),
      ),
    );

    if (selectedLocation != null) {
      weatherVM.fetchWeatherForLocation(selectedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, weatherVM, child) {
        final weather = weatherVM.weather;
        final location = weatherVM.currentLocation;

        return Scaffold(
          backgroundColor: AppTheme.neutralBg,
          body: IndexedStack(
            index: _currentTabIndex,
            children: [
              // Tab 0: TODAY (Weather Screen)
              SafeArea(
                bottom: false,
                child: RefreshIndicator(
                  color: AppTheme.primary,
                  backgroundColor: AppTheme.cardSurface,
                  onRefresh: () async {
                    await weatherVM.refreshWeather();
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      // Top Bar Branding (Matching Reference Image 2)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top branding row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primary.withOpacity(0.18),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          CupertinoIcons.cloud_sun_fill,
                                          size: 18,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppConstants.appName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Text(
                                            AppConstants.appTagline,
                                            style: TextStyle(
                                              color: AppTheme.textMuted,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // Profile / Student Avatar Badge
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          CupertinoIcons.search,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        onPressed: _openSearchScreen,
                                      ),
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          gradient: AppTheme.coralOrangeGradient,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '134',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Location Pill Bar (From Reference Image 2)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.cardSurface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppTheme.cardBorder),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.location_solid,
                                      size: 15,
                                      color: AppTheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: _openSearchScreen,
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                location?.name ??
                                                    AppConstants.defaultCityName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppTheme.primary
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                '• LIVE',
                                                style: TextStyle(
                                                  color: AppTheme.primary,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Unit Toggle (°C / °F)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isCelsius = !_isCelsius;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.cardSurfaceElevated,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: AppTheme.cardBorder),
                                        ),
                                        child: Text(
                                          _isCelsius ? '°F' : '°C',
                                          style: const TextStyle(
                                            color: AppTheme.secondary,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Favorite Heart Button
                                    GestureDetector(
                                      onTap: () {
                                        weatherVM
                                            .toggleCurrentLocationFavorite();
                                        final isFav = weatherVM.isFavorite;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isFav
                                                  ? '${location?.name ?? "Kota"} ditambahkan ke Favorit'
                                                  : '${location?.name ?? "Kota"} dihapus dari Favorit',
                                            ),
                                            duration: const Duration(seconds: 1),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        weatherVM.isFavorite
                                            ? CupertinoIcons.heart_fill
                                            : CupertinoIcons.heart,
                                        color: weatherVM.isFavorite
                                            ? AppTheme.primary
                                            : AppTheme.textMuted,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Weather Content
                      if (weatherVM.isLoading && !weatherVM.hasData)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppTheme.primary,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Memuat cuaca terkini...',
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (weatherVM.errorMessage != null &&
                          !weatherVM.hasData)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppTheme.cardSurface,
                                  borderRadius: BorderRadius.circular(24),
                                  border:
                                      Border.all(color: AppTheme.cardBorder),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      CupertinoIcons
                                          .exclamationmark_triangle_fill,
                                      color: AppTheme.secondary,
                                      size: 44,
                                    ),
                                    const SizedBox(height: 14),
                                    const Text(
                                      'Gagal Memuat Cuaca',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      weatherVM.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppTheme.textMuted,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    ElevatedButton(
                                      onPressed: () =>
                                          weatherVM.refreshWeather(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primary,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Coba Lagi'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      else if (weather != null)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(18, 4, 18, 90),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              // 1. Hero Overview Card
                              WeatherOverviewCard(
                                weather: weather,
                                isCelsius: _isCelsius,
                              ),
                              const SizedBox(height: 14),

                              // 2. Quick Action Pills (From Reference Image 2)
                              Row(
                                children: [
                                  Expanded(
                                    child: _actionPill(
                                      icon: CupertinoIcons.radiowaves_right,
                                      title: 'Live Radar',
                                      subtitle: 'Open-Meteo Sync',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _actionPill(
                                      icon: CupertinoIcons.bell,
                                      title: 'Weather Advisory',
                                      subtitle: 'Normal Conditions',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // 3. Hourly Forecast (From Reference Image 2)
                              HourlyForecastList(
                                hourly: weather.hourly,
                                isCelsius: _isCelsius,
                              ),
                              const SizedBox(height: 20),

                              // 4. 7-Day Outlook (From Reference Image 2)
                              DailyForecastList(
                                daily: weather.daily,
                                isCelsius: _isCelsius,
                              ),
                              const SizedBox(height: 20),

                              // 5. Additional Weather Metrics Grid
                              WeatherMetricsGrid(weather: weather),
                              const SizedBox(height: 28),

                              // Footer Branding
                              Center(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          CupertinoIcons.cloud_sun_fill,
                                          size: 14,
                                          color: AppTheme.primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          AppConstants.appName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      AppConstants.appTagline,
                                      style: TextStyle(
                                        color: AppTheme.textMuted,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Tab 1: SEARCH
              SearchScreen(
                onLocationSelected: (location) {
                  setState(() {
                    _currentTabIndex = 0; // Pindah otomatis kembali ke tab Today / Cuaca
                  });
                },
                onBack: () {
                  setState(() {
                    _currentTabIndex = 0; // Pindah kembali ke tab Today
                  });
                },
              ),

              // Tab 2: SETTINGS
              SettingsScreen(
                isCelsius: _isCelsius,
                onUnitChanged: (val) {
                  setState(() {
                    _isCelsius = val;
                  });
                },
              ),
            ],
          ),

          // Bottom Navigation Bar (Matching Reference Image 2 & 3)
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: AppTheme.cardSurface,
              border: Border(
                top: BorderSide(color: AppTheme.cardBorder, width: 1.0),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navItem(0, CupertinoIcons.sun_max, CupertinoIcons.sun_max_fill, 'Today'),
                    _navItem(1, CupertinoIcons.search, CupertinoIcons.search, 'Search'),
                    _navItem(2, CupertinoIcons.slider_horizontal_3, CupertinoIcons.slider_horizontal_3, 'Settings'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _actionPill({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: AppTheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _currentTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 22,
              color: isActive ? AppTheme.primary : AppTheme.textMuted,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.primary : AppTheme.textMuted,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
