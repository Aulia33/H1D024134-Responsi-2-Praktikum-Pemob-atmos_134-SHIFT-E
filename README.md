# 🌤️ Atmos_134 - Responsi Pemrograman Mobile (Flutter)

<div align="center">
  <img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/master/svgs/solid/cloud-sun.svg" width="90" height="90" alt="Atmos Logo" />
  <h1>Atmos</h1>
  <p><strong><em>Feel the sky. Know the weather.</em></strong></p>
  <p>Aplikasi Prakiraan Cuaca Modern, Estetik, dan Real-Time berbasis Flutter, REST API Open-Meteo, & Arsitektur MVVM</p>

  <p>
    <img src="https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/Architecture-MVVM%20%2B%20Provider-orange" alt="Architecture" />
    <img src="https://img.shields.io/badge/API-Open--Meteo%20Live-brightgreen" alt="Open-Meteo" />
    <img src="https://img.shields.io/badge/Storage-SharedPreferences-blue" alt="Local Storage" />
  </p>
</div>

---

## 👤 Identitas Mahasiswa

* **Nama Lengkap** : Siti Aulia Febriana
* **NIM** : H1D024134
* **Shift Baru** : E
* **Shift Lama** : B
* **Mata Kuliah** : Praktikum Pemrograman Mobile
* **Tugas** : Responsi Flutter - Aplikasi Cuaca (**Atmos_134**)

---

## 🎥 Link Video Demo Aplikasi (YouTube)

Tonton demonstrasi lengkap jalannya aplikasi Atmos_134, mulai dari splash screen, pengambilan data live cuaca, pencarian kota interaktif, penyimpanan lokal kota favorit, hingga pengaturan unit:

> 🔗 **Tautan YouTube Demo**: [https://www.youtube.com/watch?v=YOUR_VIDEO_ID_HERE](https://www.youtube.com/watch?v=YOUR_VIDEO_ID_HERE)  
> *(Silakan ganti URL di atas dengan tautan video YouTube demo aplikasi Anda)*

---

## 📸 Tangkapan Layar Aplikasi (Screenshots)

Berikut adalah dokumentasi visual dari setiap layar (*screen*) yang terdapat pada aplikasi **Atmos_134**:

### 1. Layar Utama (Splash & Home Screen)
| 🚀 Splash Screen | 🌤️ Home Screen (Hero & Hourly) | 📊 Home Screen (Metrics & 7-Day) |
| :---: | :---: | :---: |
| <img src="screenshots/splash_screen.png" width="240" alt="Splash Screen" /> | <img src="screenshots/home_screen_top.png" width="240" alt="Home Screen Hero & Hourly" /> | <img src="screenshots/home_screen_bottom.png" width="240" alt="Home Screen Metrics & 7-Day Outlook" /> |
| *Layar pembuka dengan animasi logo Atmos & tagline resmi* | *Hero overview card cuaca live, status WMO, & hourly forecast* | *Grid 4 metrik cuaca wajib & visual bar rentang suhu 7 hari* |

---

### 2. Layar Pencarian & Pengaturan (Search & Settings Screen)
| 🔍 Search Screen (Live API Query) | ⭐ Search Screen (Favorit & Riwayat) | ⚙️ Settings Screen |
| :---: | :---: | :---: |
| <img src="screenshots/search_screen_query.png" width="240" alt="Search Screen Query" /> | <img src="screenshots/search_screen_favorites.png" width="240" alt="Search Screen Favorites" /> | <img src="screenshots/settings_screen.png" width="240" alt="Settings Screen" /> |
| *Pencarian kota live ke Open-Meteo Geocoding API* | *Daftar kota favorit tersimpan & riwayat pencarian lokal* | *Preferensi unit suhu (°C/°F), angin, tekanan, & clear cache* |

> 💡 **Petunjuk Pengisian Gambar:**  
> Simpan tangkapan layar perangkat Anda ke dalam folder `screenshots/` di dalam repositori ini dengan nama file yang sesuai (`splash_screen.png`, `home_screen_top.png`, `home_screen_bottom.png`, `search_screen_query.png`, `search_screen_favorites.png`, dan `settings_screen.png`), atau gunakan tautan gambar GitHub attachment.

---

## 📱 Tentang Atmos_134

**Atmos** (Project ID: `Atmos_134`) adalah aplikasi cuaca modern, minimalis, dan estetik yang dibangun dengan Flutter. Aplikasi ini sepenuhnya terhubung ke **REST API Open-Meteo** secara dinamis (tanpa data tiruan/hardcoded) untuk menyajikan informasi cuaca terkini di seluruh penjuru dunia.

### ✨ Karakteristik & Desain Identitas
* **Sky-Inspired Dark Interface**: Latar belakang aplikasi menggunakan palet warna gelap berkelas dengan aksen gradien warna langit cerdas (`#FB7185` Coral Rose, `#FB923C` Sunset Orange, `#FBCFE8` Soft Pink, `#180E1B` Deep Midnight Plum).
* **Modern Glassmorphism**: Kartu cuaca dengan sudut lengkung halus (*border radius 24–32px*), batas elegan (*subtle borders*), dan bayangan lembut.
* **Tipografi Bersih & Profesional**: Memanfaatkan hierarki font yang rapi dan mudah dibaca secara cepat.
* **Responsif**: Tampilan mulus dan adaptif untuk berbagai ukuran resolusi layar Android.

---

## 🏛️ Arsitektur Aplikasi (MVVM)

Aplikasi dibangun dengan memisahkan kode ke dalam lapisan arsitektur **Model-View-ViewModel (MVVM)** untuk memastikan keterbacaan kode, kemudahan pengujian (*testability*), dan pemisahan tugas (*Separation of Concerns*):

```text
lib/
├── main.dart                          # Titik masuk utama & registrasi MultiProvider
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # Nama aplikasi, tagline, endpoint API, & key storage
│   ├── theme/
│   │   └── app_theme.dart             # Palet warna, tema Material 3, & glassmorphism styling
│   └── utils/
│       ├── date_helper.dart           # Pemformat tanggal, nama hari bahasa Indonesia, & jam
│       └── weather_helper.dart        # Penerjemah kode cuaca WMO (ikon, teks label, & warna)
├── models/
│   ├── location_model.dart            # Model data kota Geocoding & status favorit (JSON serialization)
│   └── weather_model.dart             # Model data serialisasi JSON cuaca terkini, hourly, & harian
├── services/
│   ├── geocoding_service.dart         # HTTP GET Client ke Open-Meteo Geocoding Search API
│   ├── storage_service.dart           # Local Storage SharedPreferences (favorit & riwayat)
│   └── weather_service.dart           # HTTP GET Client ke Open-Meteo Weather Forecast API
├── viewmodels/
│   ├── location_viewmodel.dart        # State Management pencarian kota, favorit, & riwayat lokal
│   └── weather_viewmodel.dart         # State Management cuaca, status loading, error, & refresh
└── views/
    ├── splash/
    │   └── splash_screen.dart         # Layar pembuka animasi logo Atmos & tagline
    ├── home/
    │   ├── home_screen.dart           # Layar Utama: Cuaca kota aktif, hourly forecast, 7-day outlook
    │   └── widgets/
    │       ├── daily_forecast_list.dart   # Komponen list ramalan 7 hari dengan bar rentang suhu
    │       ├── hourly_forecast_list.dart  # Komponen list horizontal prakiraan cuaca 24 jam
    │       ├── weather_metrics_grid.dart  # Grid kartu metrik (kelembapan, angin, hujan, peluang)
    │       └── weather_overview_card.dart # Kartu hero suhu besar, kondisi WMO, & feels-like
    ├── search/
    │   └── search_screen.dart         # Layar Pencarian kota live, daftar favorit, & kota populer
    └── settings/
        └── settings_screen.dart       # Layar Pengaturan preferensi unit (°C/°F), notifikasi, & cache
```

### Penjelasan Peran Setiap Layer:
1. **Model (`lib/models/`)**:
   * Merepresentasikan struktur data entitas (`WeatherModel`, `CurrentWeather`, `HourlyForecast`, `DailyForecast`, dan `LocationModel`).
   * Dilengkapi fungsi deserialisasi `fromJson()` dan serialisasi `toJson()` yang aman dari nilai null.
2. **View (`lib/views/`)**:
   * Komponen antarmuka visual murni berbasis Flutter Widget (`HomeScreen`, `SearchScreen`, `SettingsScreen`, `SplashScreen`).
   * View tidak memanggil API langsung, melainkan mengamati perubahan state dari ViewModel menggunakan widget `Consumer<WeatherViewModel>` dan `Consumer<LocationViewModel>`.
3. **ViewModel (`lib/viewmodels/`)**:
   * Berperan sebagai jembatan logika antara data dan antarmuka menggunakan kelas `ChangeNotifier`.
   * Mengelola status aplikasi: status pemuatan (`isLoading`), pesan kesalahan (`errorMessage`), kota terpilih, serta memicu render ulang UI secara reaktif melalui `notifyListeners()`.
4. **Service (`lib/services/`)**:
   * Mengisolasi interaksi dengan dunia luar: panggilan HTTP jaringan (`WeatherService`, `GeocodingService`) dan persistensi penyimpanan lokal perangkat (`StorageService`).

---

## 🌐 Integrasi REST API (Open-Meteo)

Data cuaca yang disajikan **100% nyata (live)** dari layanan RESTful API resmi Open-Meteo:

### 1. Weather Forecast API
* **Endpoint URL**: `https://api.open-meteo.com/v1/forecast`
* **Metode**: `GET`
* **Query Parameters**:
  * `latitude` & `longitude`: Titik koordinat geografis kota terpilih
  * `current`: `temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m`
  * `hourly`: `temperature_2m,weather_code,precipitation_probability`
  * `daily`: `weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max`
  * `timezone`: `auto`

#### 📋 Tabel Pemetaan 9 Field Data Cuaca Wajib ke Tampilan Aplikasi:
| No | Data yang Diwajibkan | Field API Open-Meteo | Implementasi di Model Dart | Letak Tampilan pada UI |
| :-: | :--- | :--- | :--- | :--- |
| **1** | Suhu saat ini | `current.temperature_2m` | `weather.current.temperature` | Angka derajat utama pada *Weather Overview Card* |
| **2** | Kelembapan | `current.relative_humidity_2m` | `weather.current.relativeHumidity` | Grid Metrik (*Humidity %*) & Overview Card |
| **3** | Suhu yang dirasakan | `current.apparent_temperature` | `weather.current.apparentTemperature` | Kartu Utama (*Feels like xx°*) |
| **4** | Curah hujan | `current.precipitation` | `weather.current.precipitation` | Grid Metrik (*Precipitation mm*) |
| **5** | Kode kondisi cuaca | `current.weather_code` | `weather.current.weatherCode` | Ikon & Label Teks Cuaca WMO (Cerah, Hujan, dll.) |
| **6** | Kecepatan angin | `current.wind_speed_10m` | `weather.current.windSpeed` | Grid Metrik (*Wind Speed km/h*) |
| **7** | Suhu maksimum harian | `daily.temperature_2m_max` | `daily.temperatureMax` | Indikator *H: xx°* di kartu utama & bar rentang 7 hari |
| **8** | Suhu minimum harian | `daily.temperature_2m_min` | `daily.temperatureMin` | Indikator *L: xx°* di kartu utama & bar rentang 7 hari |
| **9** | Peluang hujan maksimum | `daily.precipitation_probability_max` | `daily.precipitationProbabilityMax` | Grid Metrik (*Rain Probability %*) & Ramalan Harian |

---

### 2. Geocoding API
* **Endpoint URL**: `https://geocoding-api.open-meteo.com/v1/search`
* **Metode**: `GET`
* **Query Parameters**:
  * `name`: Kata kunci pencarian yang dimasukkan pengguna
  * `count`: `10`
  * `language`: `id`
  * `format`: `json`
* **Fungsi**: Mengubah nama kota yang diketik menjadi daftar lokasi nyata lengkap dengan koordinat lintang (*latitude*), bujur (*longitude*), provinsi/wilayah (*admin1*), dan negara.

---

## 💾 Implementasi Local Storage (SharedPreferences)

Aplikasi mengimplementasikan penyimpanan lokal persisten menggunakan package `shared_preferences: ^2.5.6`:

1. **Daftar Kota Favorit**:
   * Pengguna dapat menambahkan atau menghapus kota favorit dengan menekan tombol bintang / hati (**⭐ / ❤️**).
   * Data disimpan secara lokal dalam bentuk serialized JSON String List (`key: atmos_favorite_cities`).
   * Saat aplikasi ditutup dan dibuka kembali, daftar kota favorit langsung dimuat secara otomatis.
2. **Lokasi Terakhir (*Last Selected Location*)**:
   * Aplikasi menyimpan kota terakhir yang dilihat oleh pengguna (`key: atmos_last_city`).
   * Saat aplikasi dibuka kembali, pengguna langsung disuguhkan data cuaca kota terakhir tersebut tanpa perlu mencari ulang.
3. **Riwayat Pencarian (*Recent Searches*)**:
   * Kata kunci pencarian terakhir tersimpan lokal (`key: atmos_recent_searches`) untuk memudahkan pengguna mengakses kota yang sering dicari.

---

## 📱 Fitur Layar Aplikasi

1. **Splash Screen**: Layar pembuka dengan animasi logo Atmos, nama aplikasi, tagline *"Feel the sky. Know the weather."*, dan identitas proyek `Atmos_134`.
2. **Home / Weather Screen**:
   * Menampilkan nama kota aktif, koordinat, dan status live.
   * Kartu ringkasan cuaca utama (*Hero Card*) dengan suhu besar, kondisi WMO, suhu terasa (*feels-like*), dan batas suhu harian (*H / L*).
   * Prakiraan cuaca per jam (*Hourly Forecast 24h*) yang dapat digeser secara horizontal.
   * Ramalan cuaca 7 hari ke depan (*7-Day Outlook*) dengan visualisasi bar gradien rentang suhu terendah hingga tertinggi.
   * Grid metrik 4 parameter cuaca wajib (kelembapan udara, kecepatan angin, curah hujan, peluang hujan).
   * Kartu skor kenyamanan luar ruangan (*Outdoor Comfort Score*).
   * Fitur *Pull-to-Refresh* untuk memperbarui data cuaca langsung dari API.
3. **Search / Location Screen**:
   * Input teks interaktif pencarian nama kota di seluruh dunia.
   * Menampilkan hasil pencarian langsung dari Geocoding API.
   * Tombol satu sentuhan untuk menyimpan atau menghapus dari daftar favorit.
   * Daftar kota favorit tersimpan dan riwayat pencarian.
   * Pilihan cepat kota-kota besar di Indonesia (Jakarta, Surabaya, Bandung, Purwokerto, Yogyakarta, Bali).
4. **Settings Screen**:
   * Pengaturan preferensi satuan suhu global (°C atau °F).
   * Pengaturan satuan kecepatan angin (km/h atau mph) dan tekanan udara (hPa atau inHg).
   * Tombol *Clear Forecast Cache* untuk mereset cache lokal dan memaksa sinkronisasi ulang data cuaca.

---

## 🛠️ Penanganan Kondisi Error & Status (Handling State)

Aplikasi menangani berbagai skenario aplikasi dengan elegan:
* **Loading State**: Menampilkan indikator pemuatan halus saat aplikasi sedang meminta data ke server Open-Meteo.
* **Empty State**: Menampilkan ilustrasi dan pesan informatif saat hasil pencarian kota tidak ditemukan atau belum ada daftar favorit yang disimpan.
* **Error State**: Menampilkan pesan kesalahan jaringan yang ramah pengguna apabila koneksi internet terputus, dilengkapi dengan tombol **Coba Lagi (Retry)**.

---

## 🚀 Panduan Menjalankan Aplikasi

Ikuti langkah-langkah berikut untuk menjalankan proyek di perangkat lokal:

### 1. Prasyarat
* Flutter SDK (Versi 3.24.0 atau yang lebih baru)
* Dart SDK (Versi 3.5.0 atau yang lebih baru)
* Android Studio / VS Code dengan ekstensi Flutter & Dart
* Emulator Android atau perangkat fisik dengan fitur USB/Wireless Debugging aktif

### 2. Langkah Instalasi
1. Buka terminal atau Command Prompt, arahkan ke direktori proyek:
   ```bash
   cd D:\atmos_134
   ```

2. Ambil seluruh dependensi yang diperlukan:
   ```bash
   flutter pub get
   ```

3. Periksa status kesiapan perangkat:
   ```bash
   flutter doctor
   ```

4. Jalankan aplikasi pada perangkat yang terhubung:
   ```bash
   flutter run
   ```

5. Untuk menjalankan pengujian otomatis (*Widget Testing*):
   ```bash
   flutter test
   ```

---

## 📦 Dependensi Utama

| Package | Versi | Kegunaan |
| :--- | :--- | :--- |
| **flutter** | SDK | Framework UI multi-platform |
| **http** | `^1.2.2` | Menangani HTTP Request (GET) ke Open-Meteo REST API |
| **provider** | `^6.1.2` | Manajemen state reaktif (MVVM architecture) |
| **shared_preferences** | `^2.5.6` | Penyimpanan lokal persisten untuk kota favorit & riwayat |
| **cupertino_icons** | `^1.0.8` | Kumpulan ikon cuaca & antarmuka bergaya iOS modern |

---

<div align="center">
  <p>© 2026 Siti Aulia Febriana (H1D024134) • Atmos_134</p>
  <p><strong>DESIGNED FOR THE OPEN SKY</strong></p>
</div>
