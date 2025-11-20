import 'package:flutter/material.dart';
import 'package:youhealthy/services/auth_service.dart';
import './category_manager_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final admin = await AuthService().isAdmin();
    setState(() => _isAdmin = admin);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(title: const Text('Configurações'), subtitle: const Text('Preferências do aplicativo')),
        const Divider(),
        if (_isAdmin)
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Gerenciar Categorias'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryManagerPage())),
          ),
      ],
    );
  }
}
