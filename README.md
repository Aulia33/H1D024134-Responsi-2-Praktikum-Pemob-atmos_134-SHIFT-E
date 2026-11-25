# Atmos_134 - Responsi Pemrograman Mobile (Flutter)

<div align="center">
  <h1>🌤️ Atmos</h1>
  <p><strong>Feel the sky. Know the weather.</strong></p>
  <p><em>Aplikasi Prakiraan Cuaca Modern, Minimalis, dan Estetik Berbasis Flutter & REST API Open-Meteo</em></p>
</div>

---

## 👤 Identitas Mahasiswa

* **Nama Lengkap** : Siti Aulia Febriana
* **NIM** : H1D024134
* **Shift Baru** : E
* **Shift Lama** : B
* **Mata Kuliah** : Praktikum Pemrograman Mobile
* **Tugas** : Responsi Flutter - Aplikasi Cuaca (Atmos_134)

---

## 📱 Tentang Atmos

**Atmos** (Project: `Atmos_134`) adalah aplikasi prakiraan cuaca modern dan premium yang dikembangkan menggunakan framework **Flutter** dan bahasa pemrograman **Dart**. Aplikasi ini mengusung arsitektur **Model-View-ViewModel (MVVM)** yang bersih dan modular, terintegrasi langsung secara dinamis dengan RESTful API dari **Open-Meteo** (tanpa hardcoded data), serta dilengkapi fitur penyimpanan lokal (**Local Storage**) persisten menggunakan **SharedPreferences** untuk mengelola kota favorit dan riwayat pencarian.

### ✨ Karakteristik & Desain Identitas
* **Sky-Inspired Interface**: Latar belakang aplikasi menggunakan gradasi langit dinamis (*dynamic sky gradient*) yang menyesuaikan secara otomatis dengan kode kondisi cuaca terkini (Cerah, Berawan, Mendung, Hujan, Badai).
* **Aesthetic Glassmorphism**: Kartu metrik dan informasi cuaca dirancang semi-transparan dengan sudut membulat (*rounded card 24–32px*), batas halus (*subtle border*), dan bayangan lembut.
* **Modern Typography**: Hirarki teks profesional, bersih, dan mudah dibaca secara cepat.
* **Responsif & Nyaman**: Tata letak yang adaptif untuk berbagai ukuran layar perangkat mobile.

---

## 🏛️ Arsitektur Aplikasi (MVVM)

Aplikasi dibangun dengan memisahkan kode ke dalam lapisan arsitektur **Model-View-ViewModel (MVVM)**:

```text
lib/
├── main.dart                          # Titik masuk utama & konfigurasi MultiProvider
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # Konstanta nama aplikasi, tagline, URL API, dan storage key
│   ├── theme/
│   │   └── app_theme.dart             # Tema warna langit, gradasi dinamis, dan styling Material 3
│   └── utils/
│       ├── date_helper.dart           # Pemformat tanggal, nama hari bahasa Indonesia, dan waktu
│       └── weather_helper.dart        # Penerjemah kode cuaca WMO (ikon, label, dan warna gradasi)
├── models/
│   ├── location_model.dart            # Model data kota hasil Geocoding & lokasi favorit
│   └── weather_model.dart             # Model data serialisasi JSON cuaca terkini & ramalan harian
├── services/
│   ├── geocoding_service.dart         # Layanan HTTP GET ke Open-Meteo Geocoding Search API
│   ├── storage_service.dart           # Layanan SharedPreferences untuk favorit & riwayat pencarian
│   └── weather_service.dart           # Layanan HTTP GET ke Open-Meteo Weather Forecast API
├── viewmodels/
│   ├── location_viewmodel.dart        # Logika bisnis pencarian kota, favorit, dan riwayat
│   └── weather_viewmodel.dart         # Logika bisnis cuaca, pemuatan data, error, dan refresh
└── views/
    ├── splash/
    │   └── splash_screen.dart         # Layar pembuka dengan animasi logo Atmos & tagline
    ├── home/
    │   ├── home_screen.dart           # Layar Utama: Cuaca kota terpilih, ringkasan, metrik, & 7 hari
    │   └── widgets/
    │       ├── daily_forecast_list.dart   # Komponen daftar ramalan cuaca 7 hari ke depan
    │       ├── weather_metrics_grid.dart  # Grid kartu metrik (kelembapan, angin, hujan, peluang)
    │       └── weather_overview_card.dart # Kartu utama suhu besar, status cuaca, & terasa seperti
    └── search/
        └── search_screen.dart         # Layar Pencarian kota, daftar favorit, riwayat, & kota populer
```

### Penjelasan Peran Setiap Layer:
1. **Model**: Merepresentasikan struktur data entitas (`WeatherModel`, `CurrentWeather`, `DailyForecast`, dan `LocationModel`) yang dilengkapi method `fromJson()` dan `toJson()`.
2. **View**: Antarmuka visual murni berbasis Flutter Widget (`HomeScreen`, `SearchScreen`, `SplashScreen`). View tidak memanggil API atau local storage secara langsung, melainkan mengamati perubahan state dari ViewModel melalui widget `Consumer` / `Provider`.
3. **ViewModel**: Kelas turunan `ChangeNotifier` (`WeatherViewModel` dan `LocationViewModel`) yang mengatur status (*state*), menangani kondisi *loading*, *empty*, dan *error*, serta memicu pembaruan UI (*recomposition*) via `notifyListeners()`.
4. **Service**: Lapisan independen yang menangani komunikasi jaringan HTTP (`WeatherService`, `GeocodingService`) dan persistensi penyimpanan lokal (`StorageService`).

---

## 🌐 Integrasi REST API (Open-Meteo)

Aplikasi melakukan HTTP Request menggunakan metode **GET** ke layanan resmi Open-Meteo:

### 1. Weather Forecast API
* **Endpoint URL**: `https://api.open-meteo.com/v1/forecast`
* **Parameter Request**:
  * `latitude`: Koordinat lintang kota
  * `longitude`: Koordinat bujur kota
  * `current`: `temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m`
  * `daily`: `weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max`
  * `timezone`: `auto`
* **Pemetaan Data ke UI**:
  | Data pada Aplikasi | Parameter Field API | Keterangan |
  | :--- | :--- | :--- |
  | Suhu saat ini | `current.temperature_2m` | Ditampilkan dalam format °C |
  | Kelembapan udara | `current.relative_humidity_2m` | Ditampilkan dalam persentase (%) |
  | Suhu yang dirasakan | `current.apparent_temperature` | Menampilkan efek suhu riil |
  | Curah hujan | `current.precipitation` | Satuan milimeter (mm) |
  | Kode kondisi cuaca | `current.weather_code` | Diterjemahkan ke teks & ikon cuaca WMO |
  | Kecepatan angin | `current.wind_speed_10m` | Satuan km/jam (km/h) |
  | Suhu maksimum harian | `daily.temperature_2m_max` | Suhu tertinggi pada ramalan 7 hari |
  | Suhu minimum harian | `daily.temperature_2m_min` | Suhu terendah pada ramalan 7 hari |
  | Peluang hujan maksimum | `daily.precipitation_probability_max` | Peluang hujan tertinggi harian (%) |

### 2. Geocoding API
* **Endpoint URL**: `https://geocoding-api.open-meteo.com/v1/search`
* **Parameter Request**:
  * `name`: Kata kunci nama kota yang diketikkan pengguna (misal: *Purwokerto*, *Bandung*, *Jakarta*)
  * `count`: `10`
  * `language`: `id`
  * `format`: `json`
* **Hasil**: Mengembalikan daftar koordinat lintang/bujur, nama wilayah administratif (`admin1`), dan nama negara.

---

## 💾 Implementasi Local Storage (SharedPreferences)

Aplikasi mengimplementasikan penyimpanan lokal persisten menggunakan package `shared_preferences`:
1. **Lokasi Favorit**: Pengguna dapat menandai kota favorit dengan menekan tombol hati (**❤️**). Daftar kota favorit disimpan secara persisten dalam format JSON string list, sehingga data tetap ada saat aplikasi ditutup dan dibuka kembali.
2. **Pilihan Lokasi Terakhir**: Kota yang terakhir kali dilihat akan otomatis dimuat kembali saat aplikasi dibuka di kemudian hari.
3. **Riwayat Pencarian**: Kata kunci pencarian kota terakhir disimpan secara lokal untuk memudahkan pencarian berulang.

---

## 📱 Tampilan Layar (Minimum Screens)

1. **Splash Screen (Branding)**:
   * Menampilkan logo cuaca dengan animasi lembut, nama aplikasi **Atmos**, tagline *"Feel the sky. Know the weather."*, serta penanda proyek `Atmos_134`.
2. **Home / Weather Screen**:
   * Header kota aktif dengan indikator GPS dan tombol toggle favorit (**❤️**).
   * Kartu ringkasan cuaca utama (*Weather Overview Card*) dengan suhu besar, badge kondisi WMO, suhu yang dirasakan, dan rentang suhu tertinggi/terendah hari ini.
   * Grid metrik cuaca 4 kartu (*Weather Metrics Grid*) untuk kelembapan udara, kecepatan angin, curah hujan, dan peluang hujan.
   * Ramalan cuaca 7 hari ke depan (*7-Day Forecast*) dengan visual bar suhu dan peluang hujan.
   * Fitur *Pull-to-Refresh* untuk memperbarui data langsung dari API.
3. **Search / Location Screen**:
   * Kolom pencarian interaktif untuk mencari nama kota di seluruh dunia via Geocoding API.
   * Daftar hasil pencarian dengan tombol favorit langsung.
   * Bagian **Lokasi Favorit** yang menampilkan kota-kota tersimpan dan dapat diklik untuk langsung mengganti cuaca di layar utama.
   * Bagian **Riwayat Pencarian** dan jalan pintas ke kota-kota populer di Indonesia.

---

## 🚀 Cara Menjalankan Aplikasi

1. Pastikan Flutter SDK telah terpasang di komputer Anda:
   ```bash
   flutter doctor
   ```
2. Buka folder proyek `atmos_134`:
   ```bash
   cd D:\atmos_134
   ```
3. Unduh seluruh package dependensi:
   ```bash
   flutter pub get
   ```
4. Jalankan aplikasi pada Emulator atau Perangkat Fisik Android / Chrome:
   ```bash
   flutter run
   ```
5. Untuk menjalankan unit test & widget test:
   ```bash
   flutter test
   ```

---

## 📸 Tangkapan Layar (Screenshots)

| Splash Screen | Home / Weather Screen | Search & Favorites Screen |
| :---: | :---: | :---: |
| *(Letakkan screenshot Splash Screen di sini)* | *(Letakkan screenshot Home Screen di sini)* | *(Letakkan screenshot Search Screen di sini)* |

---

## 📝 Kesimpulan

Proyek **Atmos_134** telah memenuhi seluruh kriteria dan spesifikasi teknis penugasan Responsi Flutter:
* Bahasa Dart & Flutter Widgets Material 3 yang responsif.
* Arsitektur MVVM (Model-View-ViewModel) terpisah dan rapi.
* State management reaktif menggunakan Provider & ChangeNotifier.
* Komunikasi jaringan HTTP REST API Open-Meteo secara live (tanpa hardcoded data).
* Local Storage SharedPreferences untuk data favorit persisten.
* Penanganan status loading, data kosong, dan penanganan kesalahan jaringan yang komprehensif.
* Identitas dan tema desain modern bernuansa langit (*sky-inspired*) dengan branding resmi **Atmos**.
