# TradeVision AI

Aplikasi Flutter (Android & iOS) untuk analisis chart trading berbasis AI,
dengan pendekatan ICT (Inner Circle Trader) & Smart Money Concept (SMC).
Tema dark mode emerald green, terinspirasi TradingView.

## Menjalankan proyek

```bash
flutter pub get
flutter run
```

Build Android:
```bash
flutter build apk --release
```

Build iOS:
```bash
flutter build ios --release
```

## Struktur folder

```
lib/
  main.dart                     # Entry point, setup tema & provider
  theme/
    app_theme.dart              # Warna, gradient, ThemeData Material 3
  models/
    analysis_result.dart        # Model hasil analisis, enum Signal/Mode/Timeframe
  services/
    analysis_service.dart       # Logika pemanggilan AI (mock, siap diganti API asli)
    app_state.dart              # State global: limit harian, riwayat, settings
  screens/
    home_screen.dart            # Halaman utama "Analisis Grafik"
    chart_screen.dart           # Tab Grafik
    signals_screen.dart         # Tab Sinyal
    live_screen.dart            # Tab Live monitoring
    settings_screen.dart        # Tab Pengaturan (API keys, dll)
    history_screen.dart         # Riwayat analisis
    upgrade_screen.dart         # Halaman Upgrade Premium
    main_navigation.dart        # Bottom navigation shell
  widgets/
    app_header.dart             # Header: judul, daily limit, riwayat, upgrade
    mode_toggle.dart             # Toggle Analisis Lengkap / Sinyal Cepat
    timeframe_selector.dart      # Chip Scalping/Day/Swing/Long Term
    upload_area.dart             # Drag & drop / upload gallery-camera
    analysis_result_card.dart    # Kartu hasil: signal, entry/SL/TP, alasan AI
```

## Menghubungkan AI sungguhan (Claude / OpenAI)

`AnalysisService.analyzeChart()` saat ini mengembalikan data **mock** agar UI
bisa langsung didemokan tanpa API key. Untuk produksi:

1. Simpan API key di **Pengaturan > AI Engine** (sudah tersedia field OpenAI
   & Claude API Key, tersimpan via `SharedPreferences` melalui `AppState`).
2. Di `analysis_service.dart`, ganti isi `analyzeChart()` dengan pemanggilan
   HTTP ke endpoint vision Claude/OpenAI, kirim gambar chart (base64) +
   prompt terstruktur yang meminta output JSON mencakup: Trend, Support/
   Resistance, Market Structure, BOS, CHoCH, Order Block, Fair Value Gap,
   Liquidity Sweep, Fibonacci, EMA 20/50/200, RSI, MACD, Volume,
   Candlestick Pattern, Risk/Reward, signal BUY/SELL/WAIT, confidence,
   entry/SL/TP1/TP2, win rate, dan reasoning.
3. Parse JSON tersebut menjadi `AnalysisResult`.

## Catatan versi Android (penting)

Project ini menargetkan **compileSdk 36 / targetSdk 36**, **Android Gradle
Plugin 8.9.1**, dan **Gradle 8.13** — kombinasi yang kompatibel dengan
Flutter versi terbaru (per pertengahan 2026). Kalau di masa depan Flutter
atau AGP naik versi lagi dan build gagal dengan pesan seperti *"requires
Android Gradle plugin X.X.X or higher"* atau *"requires compileSdk X or
later"*, naikkan versi yang diminta di:
- `android/settings.gradle` (baris `com.android.application`)
- `android/gradle/wrapper/gradle-wrapper.properties` (versi Gradle, harus
  kompatibel dengan versi AGP yang dipakai)
- `android/app/build.gradle` (`compileSdk`, `targetSdk`)

## Dependency yang sengaja belum dipasang

Untuk menjaga build Android tetap ringan dan tidak gampang gagal, beberapa
package di roadmap **belum** dimasukkan ke `pubspec.yaml` karena belum ada
kode yang benar-benar memakainya:

- `firebase_core`, `firebase_auth`, `cloud_firestore` — untuk sinkronisasi
  akun. Butuh setup project Firebase + file `google-services.json` sebelum
  ditambahkan, kalau tidak build akan gagal.
- `flutter_local_notifications` — untuk notifikasi zona entry. Butuh
  konfigurasi tambahan (core library desugaring) di `android/app/build.gradle`.
- `sqflite`, `http`, `file_picker`, `path` — belum dipakai kode manapun.

Tambahkan lagi ke `pubspec.yaml` satu per satu saat benar-benar
mengimplementasikan fitur terkait, supaya kalau ada error build, gampang
dilacak dependency mana penyebabnya.

## Roadmap fitur lanjutan (belum diimplementasikan penuh di kode ini)

Fitur-fitur berikut disiapkan strukturnya (placeholder UI/komentar) namun
memerlukan integrasi native/backend tambahan:

- 📸 **Auto screenshot TradingView** — butuh WebView + screen-capture
  channel native (Android `MediaProjection`, iOS `ReplayKit`).
- 🤖 **AI mendeteksi zona Buy/Sell langsung di chart** — gambar overlay di
  atas `Image`/`CustomPainter` berdasarkan koordinat yang dikembalikan AI.
- 🎯 **Win Rate Prediction (%)** — sudah ada di model (`winRateProbability`)
  dan ditampilkan di `AnalysisResultCard`.
- 🔔 **Notifikasi zona entry** — gunakan `flutter_local_notifications`
  (sudah ada di `pubspec.yaml`) dipicu dari `LiveScreen` saat harga live
  memasuki range entry.
- 📊 **Riwayat semua analisis** — sudah ada (`HistoryScreen`, `AppState.history`);
  untuk persistensi permanen ganti ke `sqflite` atau Firestore.
- ☁️ **Sinkronisasi akun (Firebase)** — dependency `firebase_core`,
  `firebase_auth`, `cloud_firestore` sudah disiapkan di `pubspec.yaml`;
  jalankan `flutterfire configure` untuk menghubungkan project Firebase.
- 💎 **AI menggambar garis S/R, FVG, Order Block, Fibonacci otomatis** —
  gunakan `CustomPainter` di atas gambar chart yang diupload, dengan
  koordinat relatif dikembalikan oleh model vision AI.

## Catatan

Ini adalah kerangka aplikasi yang lengkap secara UI/UX dan siap dijalankan
(`flutter run`), dengan data analisis simulasi. Untuk versi produksi,
sambungkan `AnalysisService`, notifikasi live, dan Firebase sesuai roadmap
di atas.
