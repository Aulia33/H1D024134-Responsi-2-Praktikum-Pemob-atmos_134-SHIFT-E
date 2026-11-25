import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WeatherHelper {
  /// Interprets WMO Weather interpretation codes (WW)
  static WeatherInfo getInfo(int code) {
    switch (code) {
      case 0:
        return WeatherInfo(
          code: code,
          label: 'Cerah',
          englishLabel: 'Clear Sky',
          icon: CupertinoIcons.sun_max_fill,
          iconColor: AppTheme.secondary,
        );
      case 1:
        return WeatherInfo(
          code: code,
          label: 'Sebagian Cerah',
          englishLabel: 'Mainly Clear',
          icon: CupertinoIcons.sun_min_fill,
          iconColor: AppTheme.secondary,
        );
      case 2:
        return WeatherInfo(
          code: code,
          label: 'Sebagian Berawan',
          englishLabel: 'Partly Cloudy',
          icon: CupertinoIcons.cloud_sun_fill,
          iconColor: AppTheme.primary,
        );
      case 3:
        return WeatherInfo(
          code: code,
          label: 'Mendung',
          englishLabel: 'Overcast',
          icon: CupertinoIcons.cloud_fill,
          iconColor: AppTheme.tertiary,
        );
      case 45:
      case 48:
        return WeatherInfo(
          code: code,
          label: 'Berkabut',
          englishLabel: 'Foggy',
          icon: CupertinoIcons.cloud_fog_fill,
          iconColor: AppTheme.tertiary,
        );
      case 51:
      case 53:
      case 55:
        return WeatherInfo(
          code: code,
          label: 'Gerimis',
          englishLabel: 'Drizzle',
          icon: CupertinoIcons.cloud_drizzle_fill,
          iconColor: AppTheme.primary,
        );
      case 61:
      case 63:
        return WeatherInfo(
          code: code,
          label: 'Hujan Sedang',
          englishLabel: 'Moderate Rain',
          icon: CupertinoIcons.cloud_rain_fill,
          iconColor: AppTheme.primary,
        );
      case 65:
        return WeatherInfo(
          code: code,
          label: 'Hujan Lebat',
          englishLabel: 'Heavy Rain',
          icon: CupertinoIcons.cloud_heavyrain_fill,
          iconColor: AppTheme.primary,
        );
      case 71:
      case 73:
      case 75:
      case 77:
        return WeatherInfo(
          code: code,
          label: 'Salju',
          englishLabel: 'Snow',
          icon: CupertinoIcons.snow,
          iconColor: AppTheme.tertiary,
        );
      case 80:
      case 81:
      case 82:
        return WeatherInfo(
          code: code,
          label: 'Hujan Deras',
          englishLabel: 'Rain Showers',
          icon: CupertinoIcons.cloud_heavyrain_fill,
          iconColor: AppTheme.primary,
        );
      case 95:
      case 96:
      case 99:
        return WeatherInfo(
          code: code,
          label: 'Badai Petir',
          englishLabel: 'Thunderstorm',
          icon: CupertinoIcons.cloud_bolt_rain_fill,
          iconColor: AppTheme.secondary,
        );
      default:
        return WeatherInfo(
          code: code,
          label: 'Cerah Berawan',
          englishLabel: 'Partly Cloudy',
          icon: CupertinoIcons.cloud_sun_fill,
          iconColor: AppTheme.primary,
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

  WeatherInfo({
    required this.code,
    required this.label,
    required this.englishLabel,
    required this.icon,
    required this.iconColor,
  });
}
