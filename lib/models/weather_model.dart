class WeatherModel {
  final double latitude;
  final double longitude;
  final String timezone;
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final currentJson = json['current'] as Map<String, dynamic>? ?? {};
    final dailyJson = json['daily'] as Map<String, dynamic>? ?? {};
    final hourlyJson = json['hourly'] as Map<String, dynamic>? ?? {};

    // Parse hourly lists (take next 24 hours)
    final hourlyTimes = (hourlyJson['time'] as List<dynamic>?) ?? [];
    final hourlyTemps = (hourlyJson['temperature_2m'] as List<dynamic>?) ?? [];
    final hourlyCodes = (hourlyJson['weather_code'] as List<dynamic>?) ?? [];
    final hourlyProbs =
        (hourlyJson['precipitation_probability'] as List<dynamic>?) ?? [];

    final List<HourlyForecast> hourlyList = [];
    final hourlyCount = hourlyTimes.length > 24 ? 24 : hourlyTimes.length;
    for (int i = 0; i < hourlyCount; i++) {
      hourlyList.add(
        HourlyForecast(
          time: hourlyTimes[i]?.toString() ?? '',
          temperature: (hourlyTemps.length > i)
              ? (hourlyTemps[i] as num?)?.toDouble() ?? 0.0
              : 0.0,
          weatherCode: (hourlyCodes.length > i)
              ? (hourlyCodes[i] as num?)?.toInt() ?? 0
              : 0,
          precipitationProbability: (hourlyProbs.length > i)
              ? (hourlyProbs[i] as num?)?.toInt() ?? 0
              : 0,
        ),
      );
    }

    // Parse daily lists
    final times = (dailyJson['time'] as List<dynamic>?) ?? [];
    final weatherCodes = (dailyJson['weather_code'] as List<dynamic>?) ?? [];
    final tempMaxs = (dailyJson['temperature_2m_max'] as List<dynamic>?) ?? [];
    final tempMins = (dailyJson['temperature_2m_min'] as List<dynamic>?) ?? [];
    final rainProbs =
        (dailyJson['precipitation_probability_max'] as List<dynamic>?) ?? [];

    final List<DailyForecast> dailyList = [];
    final count = times.length;
    for (int i = 0; i < count; i++) {
      dailyList.add(
        DailyForecast(
          time: times[i]?.toString() ?? '',
          weatherCode: (weatherCodes.length > i)
              ? (weatherCodes[i] as num?)?.toInt() ?? 0
              : 0,
          temperatureMax: (tempMaxs.length > i)
              ? (tempMaxs[i] as num?)?.toDouble() ?? 0.0
              : 0.0,
          temperatureMin: (tempMins.length > i)
              ? (tempMins[i] as num?)?.toDouble() ?? 0.0
              : 0.0,
          precipitationProbabilityMax: (rainProbs.length > i)
              ? (rainProbs[i] as num?)?.toInt() ?? 0
              : 0,
        ),
      );
    }

    return WeatherModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone'] ?? '',
      current: CurrentWeather.fromJson(currentJson),
      hourly: hourlyList,
      daily: dailyList,
    );
  }
}

class CurrentWeather {
  final String time;
  final double temperature; // current.temperature_2m
  final int relativeHumidity; // current.relative_humidity_2m
  final double apparentTemperature; // current.apparent_temperature
  final double precipitation; // current.precipitation
  final int weatherCode; // current.weather_code
  final double windSpeed; // current.wind_speed_10m

  CurrentWeather({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: json['time']?.toString() ?? '',
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      apparentTemperature:
          (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class HourlyForecast {
  final String time;
  final double temperature;
  final int weatherCode;
  final int precipitationProbability;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.precipitationProbability,
  });
}

class DailyForecast {
  final String time;
  final int weatherCode; // daily.weather_code
  final double temperatureMax; // daily.temperature_2m_max
  final double temperatureMin; // daily.temperature_2m_min
  final int precipitationProbabilityMax; // daily.precipitation_probability_max

  DailyForecast({
    required this.time,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.precipitationProbabilityMax,
  });
}
