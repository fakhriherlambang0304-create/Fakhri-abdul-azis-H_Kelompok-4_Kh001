// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'constants/colors.dart';
// import 'theme/app_theme.dart';
// import 'widgets/app_button.dart';
// import 'firebase_options.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.light,
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _namaController = TextEditingController();
//   final TextEditingController _nimController = TextEditingController();
//   final TextEditingController _lokasiController = TextEditingController();
//   final TextEditingController _mataKuliahController = TextEditingController();

//   String? _statusKehadiran = 'Hadir';
//   bool _isSaving = false;

//   // Menyimpan data input ke Firebase Cloud Firestore
//   Future<void> simpanData() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       _isSaving = true;
//     });

//     try {
//       await FirebaseFirestore.instance.collection('praktikum').add({
//         'nama': _namaController.text.trim(),
//         'nim': _nimController.text.trim(),
//         'lokasi': _lokasiController.text.trim(),
//         'mata_kuliah': _mataKuliahController.text.trim(),
//         'status': _statusKehadiran,
//         'waktu': FieldValue.serverTimestamp(),
//       });

//       if (!mounted) return;

//       // Kosongkan form setelah data berhasil disimpan
//       _formKey.currentState!.reset();
//       _namaController.clear();
//       _nimController.clear();
//       _lokasiController.clear();
//       _mataKuliahController.clear();

//       setState(() {
//         _statusKehadiran = 'Hadir';
//       });

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           const SnackBar(
//             content: Text('Data berhasil disimpan ke Firebase!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           const SnackBar(
//             content: Text(
//               'Gagal menyimpan data. Periksa koneksi dan konfigurasi Firebase.',
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );

//       debugPrint('Error Firebase: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isSaving = false;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _namaController.dispose();
//     _nimController.dispose();
//     _lokasiController.dispose();
//     _mataKuliahController.dispose();
//     super.dispose();
//   }

//   // Widget untuk membuat field input dengan validasi
//   Widget _buildTextField({
//     required String label,
//     required TextEditingController controller,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       textInputAction: TextInputAction.next,
//       style: const TextStyle(color: Colors.black87), // teks yang diketik
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.black54),
//         prefixIcon: Icon(icon, color: Colors.black54),
//         filled: true,
//         fillColor: Colors.white, // <-- background field jadi terang
//         border: const OutlineInputBorder(),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.black26),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: AppColors.primary, width: 2),
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.trim().isEmpty) {
//           return '$label wajib diisi';
//         }
//         return null;
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Demo Aplikasi Fakhri')),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Form Input Data Praktikum',
//                   style: TextStyle(
//                     color: AppColors.textPrimary,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 const Text(
//                   'Isi data mahasiswa dan keterangan kehadiran '
//                   'untuk menyimpan data ke Firebase.',
//                   style: TextStyle(
//                     color: AppColors.textSecondary,
//                     fontSize: 14,
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 _buildTextField(
//                   label: 'Nama',
//                   controller: _namaController,
//                   icon: Icons.person_outline,
//                 ),

//                 const SizedBox(height: 16),

//                 _buildTextField(
//                   label: 'NIM',
//                   controller: _nimController,
//                   icon: Icons.badge_outlined,
//                   keyboardType: TextInputType.number,
//                 ),

//                 const SizedBox(height: 16),

//                 _buildTextField(
//                   label: 'Lokasi',
//                   controller: _lokasiController,
//                   icon: Icons.location_on_outlined,
//                 ),

//                 const SizedBox(height: 16),

//                 _buildTextField(
//                   label: 'Mata Kuliah',
//                   controller: _mataKuliahController,
//                   icon: Icons.menu_book_outlined,
//                 ),

//                 const SizedBox(height: 16),

//                 DropdownButtonFormField<String>(
//                   initialValue: _statusKehadiran,
//                   dropdownColor:
//                       Colors.white, // <-- penting! biar menu dropdown ga gelap
//                   style: const TextStyle(color: Colors.black87),
//                   decoration: const InputDecoration(
//                     labelText: 'Keterangan Kehadiran',
//                     labelStyle: TextStyle(color: Colors.black54),
//                     prefixIcon: Icon(
//                       Icons.event_available_outlined,
//                       color: Colors.black54,
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black26),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: AppColors.primary,
//                         width: 2,
//                       ),
//                     ),
//                   ),
//                   items: const [
//                     DropdownMenuItem(value: 'Hadir', child: Text('Hadir')),
//                     DropdownMenuItem(value: 'Izin', child: Text('Izin')),
//                     DropdownMenuItem(value: 'Sakit', child: Text('Sakit')),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       _statusKehadiran = value;
//                     });
//                   },
//                 ),

//                 const SizedBox(height: 24),

//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: _isSaving ? null : simpanData,
//                     icon: _isSaving
//                         ? const SizedBox(
//                             width: 18,
//                             height: 18,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Icon(Icons.cloud_upload_outlined),
//                     label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Data'),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 SizedBox(
//                   width: double.infinity,
//                   child: AppButton(
//                     label: 'Buka Github Saya',
//                     icon: Icons.code,
//                     url: 'https://github.com/kvinn-dev',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// main.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config.dart';
import 'l10n/app_localization.dart';
import 'models/admin.dart';
import 'models/user_models.dart';
import 'services/admin_service.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

// ==========================================
// MAIN APP
// ==========================================

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale locale = const Locale('id');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Method Tester',
      locale: locale,
      supportedLocales: const [Locale('id'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomeScreen(
        onLanguageChanged: (value) {
          setState(() {
            locale = Locale(value);
          });
        },
      ),
    );
  }
}

// ==========================================
// SHARED HELPERS
// ==========================================

String cleanError(Object? e) => e.toString().replaceFirst('Exception: ', '');

// Konfirmasi lalu hapus Admin. Mengembalikan true jika berhasil dihapus.
Future<bool> confirmAndDeleteAdmin(BuildContext context, Admin admin) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Hapus Admin?'),
      content: Text(
        'Admin "${admin.name}" (ID ${admin.id}) akan dihapus dari data.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );

  if (confirmed != true) return false;

  final success = await AdminService.deleteAdmin(admin.id);

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Admin "${admin.name}" (ID ${admin.id}) berhasil dihapus'
              : 'Gagal menghapus: ID ${admin.id} tidak ditemukan',
        ),
      ),
    );
  }
  return success;
}

// Input ID + tombol untuk membuka detail berdasarkan ID
class IdSearchBar extends StatefulWidget {
  final String label;
  final String hint;
  final void Function(int id) onSearch;

  const IdSearchBar({
    super.key,
    required this.label,
    required this.hint,
    required this.onSearch,
  });

  @override
  State<IdSearchBar> createState() => _IdSearchBarState();
}

class _IdSearchBarState extends State<IdSearchBar> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    final id = int.tryParse(controller.text.trim());
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan ID yang valid (angka)')),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    widget.onSearch(id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submit(),
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.numbers),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: submit,
            icon: const Icon(Icons.search),
            label: const Text('Detail'),
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: SelectableText(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  const ErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// PAGE 1 - HOME (TAB USER & ADMIN)
// ==========================================

class HomeScreen extends StatefulWidget {
  final Function(String) onLanguageChanged;

  const HomeScreen({super.key, required this.onLanguageChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<User>> futureUsers;
  late Future<List<Admin>> futureAdmins;

  @override
  void initState() {
    super.initState();
    futureUsers = _loadUsers();
    futureAdmins = AdminService.getAdmins();
  }

  Future<List<User>> _loadUsers() async {
    final data = await ApiService.getUsers();
    return data
        .map((e) => User.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  void refreshData() {
    setState(() {
      futureUsers = _loadUsers();
      futureAdmins = AdminService.getAdmins();
    });
  }

  Future<void> openUserDetail(int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserDetailScreen(id: id)),
    );
    refreshData();
  }

  Future<void> openAdminDetail(int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminDetailScreen(id: id)),
    );
    refreshData();
  }

  Future<void> showFileInfo() async {
    final userPath = await ApiService.getJsonFilePath();
    final adminPath = await AdminService.getJsonFilePath();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Penyimpanan File JSON'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'File User:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText(
              userPath,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
            const SizedBox(height: 12),
            const Text(
              'File Admin:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText(
              adminPath,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
            const SizedBox(height: 12),
            Text(
              'ID User (NIM) = $userIdFromNim, ID Admin (NIM) = $adminIdFromNim',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Future<void> resetAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Data JSON?'),
        content: const Text(
          'Data User dan Admin akan dikembalikan ke daftar awal.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ApiService.resetToDefault();
      await AdminService.resetToDefault();
      refreshData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data User & Admin berhasil di-reset ke data awal'),
          ),
        );
      }
    }
  }

  Widget _buildFutureList<T>({
    required Future<List<T>> future,
    required Widget Function(T item) itemBuilder,
  }) {
    final language = AppLocalizations.of(context)!;

    return FutureBuilder<List<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 50),
                const SizedBox(height: 12),
                Text(language.errorMessage),
                ElevatedButton(
                  onPressed: refreshData,
                  child: Text(language.retry),
                ),
              ],
            ),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return Center(child: Text(language.noData));
        }

        return RefreshIndicator(
          onRefresh: () async {
            refreshData();
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) => itemBuilder(items[index]),
          ),
        );
      },
    );
  }

  Widget _userTile(User user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            user.name.isNotEmpty ? user.name[0] : '?',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('ID ${user.id} • ${user.email}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => openUserDetail(user.id),
      ),
    );
  }

  Widget _adminTile(Admin admin) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        isThreeLine: true,
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Text(
            admin.name.isNotEmpty ? admin.name[0] : '?',
            style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          admin.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('ID ${admin.id} • ${admin.email}\n${admin.department}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          tooltip: 'Hapus Admin',
          onPressed: () async {
            final deleted = await confirmAndDeleteAdmin(context, admin);
            if (deleted) refreshData();
          },
        ),
        onTap: () => openAdminDetail(admin.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('API Method Tester'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Lokasi File JSON',
              onPressed: showFileInfo,
            ),
            IconButton(
              icon: const Icon(Icons.restore),
              tooltip: 'Reset Data JSON ke Awal',
              onPressed: resetAll,
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.language),
              onSelected: widget.onLanguageChanged,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'id', child: Text('Bahasa Indonesia')),
                PopupMenuItem(value: 'en', child: Text('English')),
              ],
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'User'),
              Tab(icon: Icon(Icons.admin_panel_settings), text: 'Admin'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ApiTesterScreen()),
            ).then((_) => refreshData());
          },
          icon: const Icon(Icons.api),
          label: const Text('Test API User'),
        ),
        body: TabBarView(
          children: [
            // TAB USER
            Column(
              children: [
                IdSearchBar(
                  label: 'Cari User berdasarkan ID',
                  hint: 'Contoh: 1 atau $userIdFromNim',
                  onSearch: openUserDetail,
                ),
                Expanded(
                  child: _buildFutureList<User>(
                    future: futureUsers,
                    itemBuilder: _userTile,
                  ),
                ),
              ],
            ),
            // TAB ADMIN
            Column(
              children: [
                IdSearchBar(
                  label: 'Cari Admin berdasarkan ID',
                  hint: 'Contoh: $adminIdFromNim',
                  onSearch: openAdminDetail,
                ),
                Expanded(
                  child: _buildFutureList<Admin>(
                    future: futureAdmins,
                    itemBuilder: _adminTile,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// PAGE - USER DETAIL
// ==========================================

class UserDetailScreen extends StatefulWidget {
  final int id;
  const UserDetailScreen({super.key, required this.id});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Future<User> future;

  @override
  void initState() {
    super.initState();
    future = ApiService.getUser(widget.id).then((json) => User.fromJson(json));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail User #${widget.id}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<User>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(message: cleanError(snapshot.error));
          }

          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0] : '?',
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DetailRow(
                      icon: Icons.numbers,
                      label: 'ID',
                      value: '${user.id}',
                    ),
                    DetailRow(
                      icon: Icons.person,
                      label: 'Nama',
                      value: user.name,
                    ),
                    DetailRow(
                      icon: Icons.email,
                      label: 'Email',
                      value: user.email,
                    ),
                    DetailRow(
                      icon: Icons.location_city,
                      label: 'Kota',
                      value: user.city,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// PAGE - ADMIN DETAIL (+ HAPUS)
// ==========================================

class AdminDetailScreen extends StatefulWidget {
  final int id;
  const AdminDetailScreen({super.key, required this.id});

  @override
  State<AdminDetailScreen> createState() => _AdminDetailScreenState();
}

class _AdminDetailScreenState extends State<AdminDetailScreen> {
  late Future<Admin> future;

  @override
  void initState() {
    super.initState();
    future = AdminService.getAdmin(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Admin #${widget.id}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Admin>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(message: cleanError(snapshot.error));
          }

          final admin = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.orange.shade100,
                          child: Text(
                            admin.name.isNotEmpty ? admin.name[0] : '?',
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DetailRow(
                          icon: Icons.numbers,
                          label: 'ID',
                          value: '${admin.id}',
                        ),
                        DetailRow(
                          icon: Icons.person,
                          label: 'Nama',
                          value: admin.name,
                        ),
                        DetailRow(
                          icon: Icons.email,
                          label: 'Email',
                          value: admin.email,
                        ),
                        DetailRow(
                          icon: Icons.apartment,
                          label: 'Departemen',
                          value: admin.department,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus Admin'),
                    onPressed: () async {
                      final deleted = await confirmAndDeleteAdmin(
                        context,
                        admin,
                      );
                      if (deleted && context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// PAGE - API METHOD TESTER (USER CRUD)
// ==========================================

class ApiTesterScreen extends StatefulWidget {
  final int? initialId;

  const ApiTesterScreen({super.key, this.initialId});

  @override
  State<ApiTesterScreen> createState() => _ApiTesterScreenState();
}

class _ApiTesterScreenState extends State<ApiTesterScreen> {
  String selectedMethod = 'GET';

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = false;

  dynamic result;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    if (widget.initialId != null) {
      idController.text = widget.initialId.toString();
    }
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendRequest() async {
    final id = int.tryParse(idController.text);

    // Validasi ID (POST memakai ID dari NIM secara otomatis)
    if (selectedMethod != 'POST' && id == null) {
      showMessage('Masukkan ID pengguna yang valid');
      return;
    }

    // Nama wajib untuk POST dan PUT (PATCH boleh kosong)
    if ((selectedMethod == 'POST' || selectedMethod == 'PUT') &&
        nameController.text.trim().isEmpty) {
      showMessage('Nama tidak boleh kosong');
      return;
    }

    // Email wajib untuk POST dan PUT
    if ((selectedMethod == 'POST' || selectedMethod == 'PUT') &&
        emailController.text.trim().isEmpty) {
      showMessage('Email tidak boleh kosong');
      return;
    }

    setState(() {
      isLoading = true;
      result = null;
      errorMessage = null;
    });

    try {
      dynamic response;

      switch (selectedMethod) {
        case 'GET':
          response = await ApiService.getUser(id!);
          break;

        case 'POST':
          response = await ApiService.createUser(
            userIdFromNim,
            nameController.text.trim(),
            emailController.text.trim(),
          );
          break;

        case 'PUT':
          response = await ApiService.updateUser(
            id!,
            nameController.text.trim(),
            emailController.text.trim(),
          );
          break;

        case 'PATCH':
          response = await ApiService.patchUser(
            id!,
            nameController.text.trim(),
          );
          break;

        case 'DELETE':
          final success = await ApiService.deleteUser(id!);
          response = {
            'success': success,
            'message': success
                ? 'Pengguna berhasil dihapus'
                : 'Gagal menghapus pengguna: ID $id tidak ditemukan',
          };
          break;
      }

      setState(() {
        result = response;
      });
    } catch (e) {
      setState(() {
        errorMessage = cleanError(e);
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isGet = selectedMethod == 'GET';
    final isPost = selectedMethod == 'POST';
    final isPut = selectedMethod == 'PUT';
    final isPatch = selectedMethod == 'PATCH';
    final isDelete = selectedMethod == 'DELETE';

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Method Tester'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Request Configuration',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih HTTP method dan masukkan data yang ingin dikirim.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // METHOD DROPDOWN
            const Text(
              'HTTP Method',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedMethod,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.api),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'GET',
                  child: Text('GET - Retrieve Data'),
                ),
                DropdownMenuItem(
                  value: 'POST',
                  child: Text('POST - Create Data'),
                ),
                DropdownMenuItem(
                  value: 'PUT',
                  child: Text('PUT - Replace Data'),
                ),
                DropdownMenuItem(
                  value: 'PATCH',
                  child: Text('PATCH - Update Data'),
                ),
                DropdownMenuItem(
                  value: 'DELETE',
                  child: Text('DELETE - Remove Data'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedMethod = value!;
                  result = null;
                  errorMessage = null;

                  // POST selalu memakai ID dari NIM
                  if (selectedMethod == 'POST') {
                    idController.text = userIdFromNim.toString();
                  } else {
                    idController.text = widget.initialId?.toString() ?? '';
                  }
                });
              },
            ),
            const SizedBox(height: 20),

            // ID INPUT
            const Text(
              'User ID',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: idController,
              readOnly: isPost,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Contoh: 1',
                helperText: isPost
                    ? 'ID otomatis dari NIM: 1000 + $nimN = $userIdFromNim'
                    : null,
                prefixIcon: const Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 20),

            // NAME INPUT
            if (!isGet && !isDelete) ...[
              const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: isPatch
                      ? 'Kosongkan untuk memakai nama saat ini'
                      : 'Masukkan nama pengguna',
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // EMAIL INPUT
            if (isPost || isPut) ...[
              const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan email pengguna',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // INFORMATION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isGet
                    ? 'GET: Mengambil data pengguna berdasarkan ID.'
                    : isPost
                    ? 'POST: Menambahkan pengguna baru dengan ID $userIdFromNim.'
                    : isPut
                    ? 'PUT: Mengganti nama dan email pengguna.'
                    : isPatch
                    ? 'PATCH: Menambahkan "${ApiService.patchSuffix.trim()}" pada nama pengguna.'
                    : 'DELETE: Menghapus pengguna berdasarkan ID.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),

            // SEND BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : sendRequest,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(isLoading ? 'Sending Request...' : 'Send Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // RESPONSE RESULT
            if (result != null || errorMessage != null) ...[
              const Text(
                'Response Result',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: errorMessage != null
                      ? Colors.red.withValues(alpha: 0.08)
                      : Colors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: errorMessage != null ? Colors.red : Colors.green,
                  ),
                ),
                child: SelectableText(
                  errorMessage != null
                      ? errorMessage!
                      : const JsonEncoder.withIndent('  ').convert(result),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
