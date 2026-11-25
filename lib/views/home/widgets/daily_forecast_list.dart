import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/weather_helper.dart';
import '../../../models/weather_model.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> daily;

  const DailyForecastList({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    if (daily.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.32),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.calendar,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              const Text(
                'Perkiraan 7 Hari ke Depan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              Text(
                'Open-Meteo',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 8),

          // Forecast rows
          ListView.separated(
            itemCount: daily.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.white12, height: 16),
            itemBuilder: (context, index) {
              final item = daily[index];
              final info = WeatherHelper.getInfo(item.weatherCode);
              final dayLabel = DateHelper.formatForecastDay(item.time, index);
              final dateLabel = DateHelper.formatShortDate(item.time);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    // Day and date
                    SizedBox(
                      width: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dayLabel,
                            style: TextStyle(
                              color: index == 0
                                  ? Colors.amberAccent
                                  : Colors.white,
                              fontSize: 14,
                              fontWeight: index == 0
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                          Text(
                            dateLabel,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Weather Icon & rain prob
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Icon(
                            info.icon,
                            size: 20,
                            color: info.iconColor,
                          ),
                          const SizedBox(width: 8),
                          if (item.precipitationProbabilityMax > 20)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    CupertinoIcons.drop_fill,
                                    size: 10,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${item.precipitationProbabilityMax}%',
                                    style: const TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Min Temp
                    SizedBox(
                      width: 38,
                      child: Text(
                        '${item.temperatureMin.round()}°',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Temperature visual bar
                    Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.lightBlueAccent, Colors.orangeAccent],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    // Max Temp
                    SizedBox(
                      width: 38,
                      child: Text(
                        '${item.temperatureMax.round()}°',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
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
