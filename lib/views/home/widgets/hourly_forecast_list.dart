import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/weather_helper.dart';
import '../../../models/weather_model.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyForecast> hourly;
  final bool isCelsius;

  const HourlyForecastList({
    super.key,
    required this.hourly,
    this.isCelsius = true,
  });

  double _convertTemp(double celsius) {
    if (isCelsius) return celsius;
    return (celsius * 9 / 5) + 32;
  }

  @override
  Widget build(BuildContext context) {
    if (hourly.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    CupertinoIcons.clock,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Hourly Forecast',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              Text(
                'Precipitation Chance',
                style: TextStyle(
                  color: AppTheme.primary.withOpacity(0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal List of Hourly Cards
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: hourly.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = hourly[index];
              final isNow = index == 0;
              final info = WeatherHelper.getInfo(item.weatherCode);
              final timeLabel = isNow ? 'Now' : DateHelper.formatTime(item.time);
              final temp = _convertTemp(item.temperature).round();

              return Container(
                width: 68,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                decoration: BoxDecoration(
                  color: isNow
                      ? AppTheme.cardSurfaceElevated
                      : AppTheme.cardSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isNow
                        ? AppTheme.primary.withOpacity(0.8)
                        : AppTheme.cardBorder,
                    width: isNow ? 1.5 : 1.0,
                  ),
                  boxShadow: isNow
                      ? [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.18),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeLabel,
                      style: TextStyle(
                        color: isNow ? AppTheme.primary : AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: isNow ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    Icon(
                      info.icon,
                      size: 22,
                      color: info.iconColor,
                    ),
                    Text(
                      '$temp°',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // Rain probability bar or text
                    Text(
                      '${item.precipitationProbability}%',
                      style: TextStyle(
                        color: item.precipitationProbability > 20
                            ? AppTheme.secondary
                            : AppTheme.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
