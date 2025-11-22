import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youhealthy/services/auth_service.dart';
import './category_manager_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isAdmin = false;
  String? _email;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final auth = AuthService();
    final admin = await auth.isAdmin();
    final loggedEmail = auth.getCurrentUserEmail();

    setState(() {
      _isAdmin = admin;
      _email = loggedEmail;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: source);

    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Escolher da galeria"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Tirar foto"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await AuthService().logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: Text(
            "Configurações",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
        ),
        const SizedBox(height: 30),

        Center(
          child: GestureDetector(
            onTap: _showImagePickerOptions,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : null,
              child: _profileImage == null
                  ? const Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.black54,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 12),

        Center(
          child: Text(
            _email ?? "Carregando...",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),

        const SizedBox(height: 40),

        if (_isAdmin) ...[
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text("Gerenciar categorias"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CategoryManagerPage()),
              );
            },
          ),
          const Divider(),
        ],
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            "Encerrar sessão",
            style: TextStyle(color: Colors.red),
          ),
          onTap: _logout,
        ),
      ],
    );
  }
}