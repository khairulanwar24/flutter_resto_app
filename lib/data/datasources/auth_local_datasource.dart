import 'package:flutter_posresto_app/data/models/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 🏠 Kelas ini mengatur penyimpanan data autentikasi secara lokal
class AuthLocalDatasource {
  // 🧩 Fungsi untuk menyimpan data autentikasi (misal token, nama user, dll)
  Future<void> saveAuthData(AuthResponseModel authResponseModel) async {
    // 1️⃣ Ambil instance dari SharedPreferences (penyimpanan lokal sederhana)
    final prefs = await SharedPreferences.getInstance();

    // 2️⃣ Ubah data model menjadi string JSON agar bisa disimpan
    // pastikan toJson() mengembalikan String (misal jsonEncode(Map<String, dynamic>))
    await prefs.setString('auth_data', authResponseModel.toJson());
  }

  // 🗑️ Fungsi untuk menghapus data autentikasi dari penyimpanan
  Future<void> removeAuthData() async {
    // 1️⃣ Ambil instance SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // 2️⃣ Hapus data dengan key 'auth_data'
    await prefs.remove('auth_data');
  }

  // 📦 Fungsi untuk mengambil data autentikasi yang sudah disimpan
  Future<AuthResponseModel?> getAuthData() async {
    // 1️⃣ Ambil instance SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // 2️⃣ Ambil string JSON yang disimpan dengan key 'auth_data'
    final authData = prefs.getString('auth_data');

    // 3️⃣ Jika data tidak ada (null), kembalikan null
    if (authData == null) return null;

    // 4️⃣ Jika ada, ubah kembali dari JSON ke objek AuthResponseModel
    return AuthResponseModel.fromJson(authData);
  }

  // ✅ Fungsi untuk mengecek apakah data autentikasi sudah disimpan atau belum
  Future<bool> isAuthDataExist() async {
    // 1️⃣ Ambil instance SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // 2️⃣ Kembalikan true kalau ada key 'auth_data', false kalau belum ada
    return prefs.containsKey('auth_data');
  }
}
