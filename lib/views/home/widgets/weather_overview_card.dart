import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/weather_helper.dart';
import '../../../models/weather_model.dart';

class WeatherOverviewCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherOverviewCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final info = WeatherHelper.getInfo(current.weatherCode);

    // Get today's min and max from daily list if available
    double? tempMax;
    double? tempMin;
    if (weather.daily.isNotEmpty) {
      tempMax = weather.daily.first.temperatureMax;
      tempMin = weather.daily.first.temperatureMin;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Weather condition icon & label badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  info.icon,
                  size: 20,
                  color: info.iconColor,
                ),
                const SizedBox(width: 8),
                Text(
                  info.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Big Main Temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                current.temperature.round().toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 88,
                  fontWeight: FontWeight.w200,
                  height: 1.0,
                  letterSpacing: -2.0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  '°C',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Apparent temperature (Suhu yang dirasakan)
          Text(
            'Terasa seperti ${current.apparentTemperature.round()}°C',
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),

          // High / Low temperatures for today
          if (tempMax != null && tempMin != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.arrow_up,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'T: ${tempMax.round()}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.arrow_down,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'R: ${tempMin.round()}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (current.time.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Text(
                    '•  Pukul ${DateHelper.formatTime(current.time)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
