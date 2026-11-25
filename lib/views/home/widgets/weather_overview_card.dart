import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/weather_helper.dart';
import '../../../models/weather_model.dart';

class WeatherOverviewCard extends StatelessWidget {
  final WeatherModel weather;
  final bool isCelsius;

  const WeatherOverviewCard({
    super.key,
    required this.weather,
    this.isCelsius = true,
  });

  double _convertTemp(double celsius) {
    if (isCelsius) return celsius;
    return (celsius * 9 / 5) + 32;
  }

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final info = WeatherHelper.getInfo(current.weatherCode);

    double? tempMax;
    double? tempMin;
    if (weather.daily.isNotEmpty) {
      tempMax = _convertTemp(weather.daily.first.temperatureMax);
      tempMin = _convertTemp(weather.daily.first.temperatureMin);
    }

    final currentTemp = _convertTemp(current.temperature).round();
    final apparentTemp = _convertTemp(current.apparentTemperature).round();
    final unit = isCelsius ? '°' : '°F';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppTheme.cardBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Condition Badge & Visual Art Container
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Weather Condition Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      info.icon,
                      size: 15,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      info.englishLabel.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),

              // Aesthetic Sun & Cloud Art Container
              Container(
                width: 72,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFB7185), Color(0xFFFB923C)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    info.icon,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Main Temperature + Feels Like
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$currentTemp$unit',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 70,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -2.0,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Feels $apparentTemp$unit',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // High / Low + Weather note
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'H: ${tempMax?.round() ?? currentTemp}$unit',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'L: ${tempMin?.round() ?? currentTemp}$unit',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                info.label,
                style: const TextStyle(
                  color: AppTheme.secondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: AppTheme.cardBorder, height: 1),
          const SizedBox(height: 16),

          // Inner Bottom 3-Column Metrics (Wind, Humidity, Rain)
          Row(
            children: [
              Expanded(
                child: _miniStat(
                  icon: CupertinoIcons.wind,
                  label: 'Wind',
                  value: '${current.windSpeed.toStringAsFixed(1)} km/h',
                  sub: current.windSpeed > 15 ? 'Breezy' : 'Gentle',
                ),
              ),
              Container(width: 1, height: 36, color: AppTheme.cardBorder),
              Expanded(
                child: _miniStat(
                  icon: CupertinoIcons.drop,
                  label: 'Humidity',
                  value: '${current.relativeHumidity}%',
                  sub: current.relativeHumidity > 75 ? 'Humid' : 'Normal',
                ),
              ),
              Container(width: 1, height: 36, color: AppTheme.cardBorder),
              Expanded(
                child: _miniStat(
                  icon: CupertinoIcons.cloud_rain,
                  label: 'Precipitation',
                  value: '${current.precipitation.toStringAsFixed(1)} mm',
                  sub: current.precipitation > 0 ? 'Rain' : 'Dry',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat({
    required IconData icon,
    required String label,
    required String value,
    required String sub,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: AppTheme.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          sub,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
