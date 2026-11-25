import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WeatherHelper {
  /// Interprets WMO Weather interpretation codes (WW)
  /// according to Open-Meteo documentation.
  static WeatherInfo getInfo(int code, {bool isDay = true}) {
    switch (code) {
      case 0:
        return WeatherInfo(
          code: code,
          label: 'Cerah',
          englishLabel: 'Clear Sky',
          icon: isDay ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_stars_fill,
          iconColor: isDay ? Colors.amberAccent : Colors.amber.shade200,
          gradient: isDay ? AppTheme.dayClearGradient : AppTheme.nightClearGradient,
        );
      case 1:
        return WeatherInfo(
          code: code,
          label: 'Sebagian Besar Cerah',
          englishLabel: 'Mainly Clear',
          icon: isDay ? CupertinoIcons.sun_min_fill : CupertinoIcons.moon_fill,
          iconColor: isDay ? Colors.amberAccent : Colors.blueGrey.shade200,
          gradient: isDay ? AppTheme.dayClearGradient : AppTheme.nightClearGradient,
        );
      case 2:
        return WeatherInfo(
          code: code,
          label: 'Sebagian Berawan',
          englishLabel: 'Partly Cloudy',
          icon: isDay ? CupertinoIcons.cloud_sun_fill : CupertinoIcons.cloud_moon_fill,
          iconColor: Colors.lightBlueAccent,
          gradient: AppTheme.dayClearGradient,
        );
      case 3:
        return WeatherInfo(
          code: code,
          label: 'Mendung / Berawan Tebal',
          englishLabel: 'Overcast',
          icon: CupertinoIcons.cloud_fill,
          iconColor: Colors.grey.shade300,
          gradient: AppTheme.cloudyGradient,
        );
      case 45:
      case 48:
        return WeatherInfo(
          code: code,
          label: 'Berkabut',
          englishLabel: 'Foggy',
          icon: CupertinoIcons.cloud_fog_fill,
          iconColor: Colors.blueGrey.shade100,
          gradient: AppTheme.cloudyGradient,
        );
      case 51:
      case 53:
      case 55:
        return WeatherInfo(
          code: code,
          label: 'Gerimis',
          englishLabel: 'Drizzle',
          icon: CupertinoIcons.cloud_drizzle_fill,
          iconColor: Colors.lightBlue.shade200,
          gradient: AppTheme.rainyGradient,
        );
      case 61:
      case 63:
        return WeatherInfo(
          code: code,
          label: 'Hujan Sedang',
          englishLabel: 'Moderate Rain',
          icon: CupertinoIcons.cloud_rain_fill,
          iconColor: Colors.blue.shade300,
          gradient: AppTheme.rainyGradient,
        );
      case 65:
        return WeatherInfo(
          code: code,
          label: 'Hujan Lebat',
          englishLabel: 'Heavy Rain',
          icon: CupertinoIcons.cloud_heavyrain_fill,
          iconColor: Colors.blue.shade400,
          gradient: AppTheme.rainyGradient,
        );
      case 71:
      case 73:
      case 75:
      case 77:
        return WeatherInfo(
          code: code,
          label: 'Hujan Salju',
          englishLabel: 'Snowfall',
          icon: CupertinoIcons.snow,
          iconColor: Colors.white,
          gradient: AppTheme.cloudyGradient,
        );
      case 80:
      case 81:
      case 82:
        return WeatherInfo(
          code: code,
          label: 'Hujan Deras / Showers',
          englishLabel: 'Rain Showers',
          icon: CupertinoIcons.cloud_heavyrain_fill,
          iconColor: Colors.blue.shade300,
          gradient: AppTheme.rainyGradient,
        );
      case 95:
      case 96:
      case 99:
        return WeatherInfo(
          code: code,
          label: 'Badai Petir',
          englishLabel: 'Thunderstorm',
          icon: CupertinoIcons.cloud_bolt_rain_fill,
          iconColor: Colors.amber,
          gradient: AppTheme.nightClearGradient,
        );
      default:
        return WeatherInfo(
          code: code,
          label: 'Cerah Berawan',
          englishLabel: 'Clear / Clouds',
          icon: CupertinoIcons.cloud_sun_fill,
          iconColor: Colors.lightBlueAccent,
          gradient: AppTheme.dayClearGradient,
        );
    }
  }
}

class WeatherInfo {
  final int code;
  final String label;
  final String englishLabel;
  final IconData icon;
  final Color iconColor;
  final LinearGradient gradient;

  WeatherInfo({
    required this.code,
    required this.label,
    required this.englishLabel,
    required this.icon,
    required this.iconColor,
    required this.gradient,
  });
}
