import "package:shared_preferences/shared_preferences.dart";
import 'dart:convert';
import 'dart:developer' as developer;

class LocalStorageService {
  static Future<void> saveUserData(String name, String surname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('surname', surname);
  }

  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? surname = prefs.getString('surname');
    return {'name': name, 'surname': surname};
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('surname');
  }

  // Login credentials methods
  static Future<void> saveLoginCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  static Future<Map<String, String?>> getLoginCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    return {'username': username, 'password': password};
  }

  static Future<void> clearLoginCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
  }

  // User registration and login methods
  static Future<bool> registerUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    username = username.trim();
    password = password.trim();

    // Kullanıcı zaten var mı kontrol et
    if (await userExists(username)) {
      return false; // Kullanıcı zaten kayıtlı
    }

    // Mevcut kullanıcı listesini al
    List<Map<String, String>> users = await getAllUsers();
    
    // Yeni kullanıcı ekle
    users.add({
      'username': username,
      'password': password,
    });

    // Kullanıcı listesini kaydet
    String usersJson = jsonEncode(users);
    await prefs.setString('registered_users', usersJson);
    developer.log('Kullanıcı kaydedildi: $username', name: 'LocalStorageService');
    developer.log('registered_users: $usersJson', name: 'LocalStorageService');
    return true; // Kayıt başarılı
  }

  static Future<bool> loginUser(String username, String password) async {
    username = username.trim();
    password = password.trim();

    List<Map<String, String>> users = await getAllUsers();

    developer.log('loginUser çağrıldı: $username', name: 'LocalStorageService');
    developer.log('Kayıtlı kullanıcılar: $users', name: 'LocalStorageService');

    // Kullanıcıyı bul ve şifreyi kontrol et
    for (var user in users) {
      final u = (user['username'] ?? '').toString().trim();
      final p = (user['password'] ?? '').toString().trim();
      if (u == username && p == password) {
        developer.log('Giriş başarılı: $username', name: 'LocalStorageService');
        return true; // Giriş başarılı
      }
    }
    developer.log('Giriş başarısız: $username', name: 'LocalStorageService');
    return false; // Giriş başarısız
  }

  static Future<bool> userExists(String username) async {
    username = username.trim();
    List<Map<String, String>> users = await getAllUsers();
    return users.any((user) => (user['username'] ?? '').toString().trim() == username);
  }

  static Future<List<Map<String, String>>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('registered_users');
    
    if (usersJson == null || usersJson.isEmpty) {
      return [];
    }

    try {
      final decodedDynamic = jsonDecode(usersJson);
      if (decodedDynamic is List) {
        final List<Map<String, String>> users = [];
        for (var item in decodedDynamic) {
          if (item is Map) {
            users.add({
              'username': item['username']?.toString() ?? '',
              'password': item['password']?.toString() ?? '',
            });
          }
        }
        return users;
      }
      return [];
    } catch (e) {
      developer.log('getAllUsers decode error: $e', name: 'LocalStorageService', level: 1000);
      return [];
    }
  }

  static Future<void> clearAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('registered_users');
  }
}