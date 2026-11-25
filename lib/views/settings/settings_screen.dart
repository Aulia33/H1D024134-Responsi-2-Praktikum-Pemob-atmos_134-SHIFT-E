import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final bool isCelsius;
  final ValueChanged<bool> onUnitChanged;

  const SettingsScreen({
    super.key,
    required this.isCelsius,
    required this.onUnitChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _alertsEnabled = true;
  bool _morningBriefing = true;
  bool _rainDetection = false;
  bool _dynamicTheme = true;
  String _windUnit = 'km/h';
  String _pressureUnit = 'hPa';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                CupertinoIcons.cloud_sun_fill,
                size: 18,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              AppConstants.appName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 40),
        physics: const BouncingScrollPhysics(),
        children: [
          // 1. Atmospheric Clarity Header Banner (From Image 3)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppTheme.heroCardGradient,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'ATMOSPHERIC CLARITY',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        AppConstants.appTagline,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Live telemetry, satellite sync, and tailored forecasts calibrated to your microclimate.',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: AppTheme.coralOrangeGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    CupertinoIcons.cloud_fill,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. PREFERENCES SECTION
          _sectionHeader('PREFERENCES', 'Telemetry Units'),
          const SizedBox(height: 12),

          // Temperature Scale
          _settingCard(
            icon: CupertinoIcons.thermometer,
            title: 'Temperature Scale',
            subtitle: 'Select Imperial (°F) or Metric (°C) units',
            trailing: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppTheme.cardSurfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _unitButton('°C', widget.isCelsius, () => widget.onUnitChanged(true)),
                  _unitButton('°F', !widget.isCelsius, () => widget.onUnitChanged(false)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Wind Speed Unit
          _settingCard(
            icon: CupertinoIcons.wind,
            title: 'Wind Speed',
            subtitle: 'Current unit: $_windUnit',
            trailing: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppTheme.cardSurfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _unitButton('km/h', _windUnit == 'km/h', () => setState(() => _windUnit = 'km/h')),
                  _unitButton('mph', _windUnit == 'mph', () => setState(() => _windUnit = 'mph')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Atmospheric Pressure Unit
          _settingCard(
            icon: CupertinoIcons.gauge,
            title: 'Atmospheric Pressure',
            subtitle: 'Standard sea level: $_pressureUnit',
            trailing: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppTheme.cardSurfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _unitButton('hPa', _pressureUnit == 'hPa', () => setState(() => _pressureUnit = 'hPa')),
                  _unitButton('inHg', _pressureUnit == 'inHg', () => setState(() => _pressureUnit = 'inHg')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Atmospheric Sky Theme
          _settingCard(
            icon: CupertinoIcons.moon_stars,
            title: 'Atmospheric Sky Theme',
            subtitle: 'Adaptive twilight & dynamic solar tracking',
            trailing: CupertinoSwitch(
              value: _dynamicTheme,
              activeColor: AppTheme.primary,
              onChanged: (val) => setState(() => _dynamicTheme = val),
            ),
          ),
          const SizedBox(height: 24),

          // 3. ALERTS & BRIEFINGS
          _sectionHeader('ALERTS & BRIEFINGS', 'Real-time Radar'),
          const SizedBox(height: 12),
          _settingCard(
            icon: CupertinoIcons.exclamationmark_triangle,
            title: 'Severe Weather Alerts',
            subtitle: 'Immediate push priority via Open-Meteo alerts',
            trailing: CupertinoSwitch(
              value: _alertsEnabled,
              activeColor: AppTheme.primary,
              onChanged: (val) => setState(() => _alertsEnabled = val),
            ),
          ),
          const SizedBox(height: 10),
          _settingCard(
            icon: CupertinoIcons.sunrise,
            title: 'Daily Morning Briefing',
            subtitle: 'Sunrise outlook, UV index, & precipitation odds',
            trailing: CupertinoSwitch(
              value: _morningBriefing,
              activeColor: AppTheme.primary,
              onChanged: (val) => setState(() => _morningBriefing = val),
            ),
          ),
          const SizedBox(height: 10),
          _settingCard(
            icon: CupertinoIcons.umbrella,
            title: 'Rain Start / Stop Detection',
            subtitle: 'Hyper-local precipitation alerts within 15 mins',
            trailing: CupertinoSwitch(
              value: _rainDetection,
              activeColor: AppTheme.primary,
              onChanged: (val) => setState(() => _rainDetection = val),
            ),
          ),
          const SizedBox(height: 24),

          // 4. DATA & STORAGE
          _sectionHeader('DATA & STORAGE', 'Local SharedPreferences'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.cardSurface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(CupertinoIcons.archivebox, size: 18, color: AppTheme.secondary),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Local Storage Footprint',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Favorites, recent searches, & offline cache',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Cache ramalan cuaca berhasil dibersihkan'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.refresh_bold, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Clear Forecast Cache',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, String sub) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.secondary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        Text(
          sub,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _settingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _unitButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
