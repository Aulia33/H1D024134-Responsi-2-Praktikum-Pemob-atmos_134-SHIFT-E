import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

    return GridView.count(
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
          iconColor: Colors.lightBlueAccent,
          label: 'Kelembapan Udara',
          value: '${current.relativeHumidity}%',
          subtitle: current.relativeHumidity > 80
              ? 'Tinggi (Lembap)'
              : current.relativeHumidity > 50
                  ? 'Normal / Nyaman'
                  : 'Kering',
        ),

        // 2. Kecepatan Angin
        _MetricCard(
          icon: CupertinoIcons.wind,
          iconColor: Colors.tealAccent,
          label: 'Kecepatan Angin',
          value: '${current.windSpeed.toStringAsFixed(1)} km/h',
          subtitle: current.windSpeed > 20
              ? 'Angin Kencang'
              : current.windSpeed > 10
                  ? 'Sepoi-sepoi'
                  : 'Tenang',
        ),

        // 3. Curah Hujan
        _MetricCard(
          icon: CupertinoIcons.cloud_rain_fill,
          iconColor: Colors.cyanAccent,
          label: 'Curah Hujan',
          value: '${current.precipitation.toStringAsFixed(1)} mm',
          subtitle: current.precipitation > 5.0
              ? 'Hujan Deras'
              : current.precipitation > 0.0
                  ? 'Hujan Ringan'
                  : 'Tidak Ada Hujan',
        ),

        // 4. Peluang Hujan Hari Ini
        _MetricCard(
          icon: CupertinoIcons.umbrella_fill,
          iconColor: Colors.indigoAccent.shade100,
          label: 'Peluang Hujan',
          value: '$rainProb%',
          subtitle: rainProb > 60
              ? 'Sedia Payung'
              : rainProb > 30
                  ? 'Kemungkinan Hujan'
                  : 'Kecil Peluang Hujan',
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
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
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
