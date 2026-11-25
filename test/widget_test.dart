import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atmos_134/main.dart';
import 'package:atmos_134/core/constants/app_constants.dart';
import 'package:atmos_134/core/utils/weather_helper.dart';
import 'package:atmos_134/models/location_model.dart';
import 'package:atmos_134/models/weather_model.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('AtmosApp smoke test - splash screen displays brand and tagline',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AtmosApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Expect Atmos app name and tagline
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.appTagline), findsOneWidget);
    expect(find.text(AppConstants.projectName), findsOneWidget);

    // Drain timer
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pump(const Duration(milliseconds: 500));
  });

  test('LocationModel serialization test', () {
    final location = LocationModel(
      name: 'Purwokerto',
      latitude: -7.42139,
      longitude: 109.23444,
      country: 'Indonesia',
      admin1: 'Jawa Tengah',
      isFavorite: true,
    );

    final json = location.toJson();
    final fromJson = LocationModel.fromJson(json);

    expect(fromJson.name, 'Purwokerto');
    expect(fromJson.latitude, -7.42139);
    expect(fromJson.isFavorite, true);
    expect(fromJson.subtitle, 'Jawa Tengah, Indonesia');
  });

  test('WeatherHelper WMO code mapping test', () {
    final clear = WeatherHelper.getInfo(0);
    expect(clear.label, 'Cerah');

    final rain = WeatherHelper.getInfo(65);
    expect(rain.label, 'Hujan Lebat');

    final storm = WeatherHelper.getInfo(95);
    expect(storm.label, 'Badai Petir');
  });

  test('WeatherModel JSON deserialization test', () {
    final mockJson = {
      "latitude": -7.42,
      "longitude": 109.23,
      "timezone": "Asia/Jakarta",
      "current": {
        "time": "2026-11-25T16:00",
        "temperature_2m": 26.5,
        "relative_humidity_2m": 88,
        "apparent_temperature": 30.2,
        "precipitation": 1.2,
        "weather_code": 80,
        "wind_speed_10m": 6.5
      },
      "daily": {
        "time": ["2026-11-25"],
        "weather_code": [80],
        "temperature_2m_max": [29.5],
        "temperature_2m_min": [23.1],
        "precipitation_probability_max": [85]
      }
    };

    final weather = WeatherModel.fromJson(mockJson);
    expect(weather.current.temperature, 26.5);
    expect(weather.current.relativeHumidity, 88);
    expect(weather.current.apparentTemperature, 30.2);
    expect(weather.daily.length, 1);
    expect(weather.daily.first.temperatureMax, 29.5);
    expect(weather.daily.first.precipitationProbabilityMax, 85);
  });
}
