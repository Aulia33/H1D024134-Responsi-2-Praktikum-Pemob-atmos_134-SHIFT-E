import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/weather_helper.dart';
import '../../models/location_model.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../search/search_screen.dart';
import 'widgets/daily_forecast_list.dart';
import 'widgets/weather_metrics_grid.dart';
import 'widgets/weather_overview_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

        // Dynamic gradient based on current weather code
        final gradient = weather != null
            ? WeatherHelper.getInfo(weather.current.weatherCode).gradient
            : AppTheme.dayClearGradient;

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(gradient: gradient),
            child: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                color: AppTheme.skyBlue,
                backgroundColor: Colors.white,
                onRefresh: () async {
                  await weatherVM.refreshWeather();
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    // Modern App Bar Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        child: Row(
                          children: [
                            // Location info
                            Expanded(
                              child: GestureDetector(
                                onTap: _openSearchScreen,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.location_solid,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            location?.name ?? AppConstants.defaultCityName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          CupertinoIcons.chevron_down,
                                          size: 14,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      location?.subtitle ??
                                          '${AppConstants.defaultAdmin1}, ${AppConstants.defaultCountry}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.85),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Favorite Button
                            IconButton(
                              onPressed: () {
                                weatherVM.toggleCurrentLocationFavorite();
                                final isFav = weatherVM.isFavorite;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFav
                                          ? '${location?.name ?? "Kota"} ditambahkan ke Favorit'
                                          : '${location?.name ?? "Kota"} dihapus dari Favorit',
                                    ),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                weatherVM.isFavorite
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color: weatherVM.isFavorite
                                    ? AppTheme.accentRed
                                    : Colors.white,
                                size: 24,
                              ),
                              tooltip: 'Favorit',
                            ),

                            // Search Button
                            IconButton(
                              onPressed: _openSearchScreen,
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.search,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              tooltip: 'Cari Kota',
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Content Body: Loading, Error, or Weather Data
                    if (weatherVM.isLoading && !weatherVM.hasData)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Memuat cuaca terkini...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (weatherVM.errorMessage != null && !weatherVM.hasData)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    CupertinoIcons.exclamationmark_triangle_fill,
                                    color: Colors.amberAccent,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Gagal Memuat Cuaca',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    weatherVM.errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: () => weatherVM.refreshWeather(),
                                    icon: const Icon(CupertinoIcons.refresh),
                                    label: const Text('Coba Lagi'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppTheme.skyBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    else if (weather != null)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 36),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // 1. Weather Overview Card
                            WeatherOverviewCard(weather: weather),
                            const SizedBox(height: 18),

                            // 2. Weather Metrics Grid
                            WeatherMetricsGrid(weather: weather),
                            const SizedBox(height: 18),

                            // 3. Daily Forecast (7 Hari ke Depan)
                            DailyForecastList(daily: weather.daily),
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
                                        size: 16,
                                        color: Colors.white70,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        AppConstants.appName,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.85),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    AppConstants.appTagline,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.65),
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
          ),
        );
      },
    );
  }
}
