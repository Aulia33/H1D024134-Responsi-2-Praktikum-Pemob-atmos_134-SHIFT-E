import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/weather_helper.dart';
import '../../../models/weather_model.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> daily;
  final bool isCelsius;

  const DailyForecastList({
    super.key,
    required this.daily,
    this.isCelsius = true,
  });

  double _convertTemp(double celsius) {
    if (isCelsius) return celsius;
    return (celsius * 9 / 5) + 32;
  }

  @override
  Widget build(BuildContext context) {
    if (daily.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppTheme.cardBorder,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    CupertinoIcons.calendar,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '7-Day Outlook',
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
                'Open-Meteo Sync',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppTheme.cardBorder, height: 1),
          const SizedBox(height: 10),

          // 7-Day Rows
          ListView.separated(
            itemCount: daily.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) =>
                const Divider(color: AppTheme.cardBorder, height: 16),
            itemBuilder: (context, index) {
              final item = daily[index];
              final info = WeatherHelper.getInfo(item.weatherCode);
              final dayLabel = DateHelper.formatForecastDay(item.time, index);
              final isToday = index == 0;
              final maxTemp = _convertTemp(item.temperatureMax).round();
              final minTemp = _convertTemp(item.temperatureMin).round();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    // Day name
                    SizedBox(
                      width: 72,
                      child: Text(
                        dayLabel,
                        style: TextStyle(
                          color: isToday ? AppTheme.primary : AppTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),

                    // Weather Icon & rain prob
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Icon(
                            info.icon,
                            size: 18,
                            color: info.iconColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${item.precipitationProbabilityMax}%',
                            style: TextStyle(
                              color: item.precipitationProbabilityMax > 20
                                  ? AppTheme.primary
                                  : AppTheme.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Min Temp
                    SizedBox(
                      width: 32,
                      child: Text(
                        '$minTemp°',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Colored gradient temperature bar (Orange to Coral Pink)
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          gradient: AppTheme.orangePinkBarGradient,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),

                    // Max Temp
                    SizedBox(
                      width: 32,
                      child: Text(
                        '$maxTemp°',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
