import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/weather_model.dart';

class WeatherMetricsGrid extends StatelessWidget {
  final WeatherModel weather;

  const WeatherMetricsGrid({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final rainProb = weather.daily.isNotEmpty
        ? weather.daily.first.precipitationProbabilityMax
        : 0;

    return Column(
      children: [
        // 2x2 Grid of Required Metrics
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.55,
          children: [
            // 1. Kelembapan Udara
            _MetricCard(
              icon: CupertinoIcons.drop_fill,
              iconColor: AppTheme.primary,
              label: 'HUMIDITY',
              value: '${current.relativeHumidity}%',
              subtitle: current.relativeHumidity > 80
                  ? 'High Humidity'
                  : current.relativeHumidity > 50
                      ? 'Comfortable'
                      : 'Dry Air',
            ),

            // 2. Kecepatan Angin
            _MetricCard(
              icon: CupertinoIcons.wind,
              iconColor: AppTheme.secondary,
              label: 'WIND SPEED',
              value: '${current.windSpeed.toStringAsFixed(1)} km/h',
              subtitle: current.windSpeed > 20
                  ? 'Strong Breeze'
                  : current.windSpeed > 10
                      ? 'Moderate'
                      : 'Light Breeze',
            ),

            // 3. Curah Hujan
            _MetricCard(
              icon: CupertinoIcons.cloud_rain_fill,
              iconColor: AppTheme.tertiary,
              label: 'PRECIPITATION',
              value: '${current.precipitation.toStringAsFixed(1)} mm',
              subtitle: current.precipitation > 5.0
                  ? 'Heavy Showers'
                  : current.precipitation > 0.0
                      ? 'Light Rain'
                      : 'No Rain',
            ),

            // 4. Peluang Hujan Hari Ini
            _MetricCard(
              icon: CupertinoIcons.umbrella_fill,
              iconColor: AppTheme.primary,
              label: 'RAIN PROBABILITY',
              value: '$rainProb%',
              subtitle: rainProb > 60
                  ? 'High Chance'
                  : rainProb > 30
                      ? 'Scattered Rain'
                      : 'Low Chance',
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Outdoor Comfort Score Banner (From Reference Image 2)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.cardSurface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.compass,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Outdoor Comfort Score',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Ideal for running, cycling & outdoor activities',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppTheme.coralOrangeGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Text(
                      '9.2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(
                      CupertinoIcons.star_fill,
                      color: Colors.white,
                      size: 11,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppTheme.cardBorder,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
