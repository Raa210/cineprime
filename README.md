# CinePrime 🎬

CinePrime adalah aplikasi katalog film modern yang dibangun menggunakan Flutter. Aplikasi ini menyajikan informasi terbaru seputar film, memungkinkan pengguna untuk mencari film, melihat detail, menonton cuplikan trailer (via YouTube), membaca ulasan, dan menemukan film serupa dengan antarmuka yang elegan dan premium.

Aplikasi ini menggunakan **TMDB (The Movie Database) API** sebagai sumber data utamanya.

## ✨ Fitur Utama

- **Discover Movies**: Tampilan daftar film-film populer dan terbaru di halaman utama.
- **Pencarian Film**: Mencari judul film secara real-time langsung dari halaman utama.
- **Detail Lengkap**: Melihat informasi detail sebuah film, termasuk poster, backdrop, sinopsis, rating, durasi, dan daftar genre.
- **Trailer YouTube**: Membuka cuplikan trailer atau teaser langsung ke dalam aplikasi YouTube atau browser bawaan.
- **Ulasan Pengguna**: Menampilkan ulasan atau review pengguna mengenai film tersebut, lengkap dengan avatar dan rating. Terdapat juga fitur "Lihat Semua" dengan *infinite scrolling pagination*.
- **Film Serupa**: Rekomendasi film lain yang mirip dengan film yang sedang dilihat.
- **UI Premium**: Desain gelap (*dark theme*) bergaya khas aplikasi streaming dengan sentuhan warna aksen merah dan emas yang elegan.

## 🛠️ Teknologi & Library

Proyek ini menggunakan Flutter (versi stabil terbaru) dengan beberapa *dependency* utama, antara lain:

- **`dio`**: Digunakan untuk menangani *HTTP request* ke API TMDB secara efisien.
- **`cached_network_image`**: Mengoptimalkan pemuatan dan *caching* gambar-gambar (poster, backdrop, avatar).
- **`url_launcher`**: Digunakan untuk meluncurkan URL (mengalihkan pengguna ke YouTube saat menekan trailer).

## 🗂️ Struktur Proyek

```
lib/
├── main.dart                      # Entry point aplikasi
├── models/                        # Model data JSON (parsing)
│   ├── movie_detail_model.dart
│   ├── movie_model.dart
│   ├── review_model.dart
│   └── video_model.dart
├── pages/                         # Halaman UI
│   ├── all_reviews_page.dart      # Halaman daftar semua ulasan (pagination)
│   ├── movie_detail_page.dart     # Halaman detail film (poster, sinopsis, trailer)
│   └── movie_list_page.dart       # Halaman utama (discover & search)
└── services/                      # Logika komunikasi ke API
    ├── api_constants.dart         # Konfigurasi Base URL & Token TMDB
    ├── api_service_dio.dart       # Fungsi-fungsi pemanggilan HTTP request menggunakan Dio
    └── api_service_http.dart      # (Opsional/Legacy) Alternatif service API
```

## 🚀 Cara Menjalankan (Getting Started)

1. **Pastikan lingkungan sudah siap**: Flutter SDK terinstal di sistem Anda.
2. **Klon / Unduh** repositori proyek ini.
3. **Instal Dependency**:
   Jalankan perintah ini di terminal pada *root folder* proyek:
   ```bash
   flutter pub get
   ```
4. **Token API TMDB (Opsional jika ingin mengganti)**:
   Secara *default*, proyek ini menggunakan *Read Access Token* yang sudah tertanam di file `lib/services/api_constants.dart`. Jika Anda ingin menggunakan akun TMDB Anda sendiri, Anda dapat mengganti nilai `bearerToken` pada file tersebut.
5. **Jalankan Aplikasi**:
   Jalankan perintah berikut:
   ```bash
   flutter run
   ```

> **Catatan Khusus Platform Web & Android**: 
> - Jika ada error seperti `MissingPluginException` setelah menambahkan `url_launcher`, pastikan Anda **menghentikan sepenuhnya** aplikasi (tekan `q` atau `Ctrl+C` di terminal) lalu jalankan kembali `flutter run`.
> - Proyek ini juga sudah menambahkan `<queries>` intent `https` di `AndroidManifest.xml` agar `url_launcher` dapat beroperasi normal pada Android 11+.

## 📝 Referensi

- [The Movie Database (TMDB) API](https://developer.themoviedb.org/docs)
- [Dokumentasi Flutter](https://docs.flutter.dev/)
