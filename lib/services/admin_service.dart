import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../config.dart';
import '../models/admin.dart';

class AdminService {
  static const String fileName = 'admins.json';

  // Path file admins.json di penyimpanan internal perangkat
  static Future<File> getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  static Future<String> getJsonFilePath() async {
    final file = await getLocalFile();
    return file.path;
  }

  // Buat admins.json berisi data awal jika belum ada
  static Future<File> _ensureFileInitialized() async {
    final file = await getLocalFile();
    if (!await file.exists()) {
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(_defaultAdmins),
      );
    }
    return file;
  }

  static Future<List<Map<String, dynamic>>> _readJsonFile() async {
    final file = await _ensureFileInitialized();
    final contents = await file.readAsString();
    final list = jsonDecode(contents) as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> _writeJsonFile(List<Map<String, dynamic>> admins) async {
    final file = await getLocalFile();
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(admins),
    );
  }

  // GET: mengambil seluruh data Admin
  static Future<List<Admin>> getAdmins() async {
    await Future.delayed(const Duration(milliseconds: 250));
    final admins = await _readJsonFile();
    return admins.map((json) => Admin.fromJson(json)).toList();
  }

  // GET: mengambil satu Admin berdasarkan ID
  static Future<Admin> getAdmin(int id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final admins = await _readJsonFile();
    final index = admins.indexWhere((e) => e['id'] == id);

    if (index == -1) {
      throw Exception('Data admin dengan ID $id tidak ditemukan');
    }
    return Admin.fromJson(admins[index]);
  }

  // DELETE: menghapus Admin berdasarkan ID
  static Future<bool> deleteAdmin(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final admins = await _readJsonFile();
    final index = admins.indexWhere((e) => e['id'] == id);

    if (index == -1) {
      return false;
    }

    admins.removeAt(index);
    await _writeJsonFile(admins);
    return true;
  }

  // Kembalikan admins.json ke data awal
  static Future<void> resetToDefault() async {
    final file = await getLocalFile();
    if (await file.exists()) {
      await file.delete();
    }
    await _ensureFileInitialized();
  }

  // Data awal Admin (termasuk Admin dengan ID 2000 + N = 2212)
  static final List<Map<String, dynamic>> _defaultAdmins = [
    {
      'id': 2001,
      'name': 'Budi Santoso',
      'email': 'budi.santoso@admin.id',
      'department': 'IT Support',
    },
    {
      'id': 2002,
      'name': 'Siti Rahma',
      'email': 'siti.rahma@admin.id',
      'department': 'Human Resources',
    },
    {
      'id': 2003,
      'name': 'Andi Wijaya',
      'email': 'andi.wijaya@admin.id',
      'department': 'Keuangan',
    },
    {
      'id': 2004,
      'name': 'Dewi Lestari',
      'email': 'dewi.lestari@admin.id',
      'department': 'Akademik',
    },
    {
      'id': adminIdFromNim,
      'name': 'Fakhri',
      'email': 'fakhri.admin@admin.id',
      'department': 'Teknologi Informasi',
    },
  ];
}
