import 'package:flutter/material.dart';
import 'package:youhealthy/services/firestore_service.dart';
import 'package:youhealthy/services/auth_service.dart';

class CategoryManagerPage extends StatefulWidget {
  const CategoryManagerPage({super.key});

  @override
  State<CategoryManagerPage> createState() => _CategoryManagerPageState();
}

class _CategoryManagerPageState extends State<CategoryManagerPage> {
  final _service = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isAdmin = false;
  String? _editingId;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final admin = await AuthService().isAdmin();
    setState(() => _isAdmin = admin);
  }

  void _startCreate() {
    _editingId = null;
    _nameController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nova categoria'),
        content: Form(
          key: _formKey,
          child: TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nome'), validator: (v) => v == null || v.isEmpty ? 'Insira o nome' : null),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
              await _service.addCategory(_nameController.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  void _startEdit(String id, String currentName) {
    _editingId = id;
    _nameController.text = currentName;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar categoria'),
        content: Form(
          key: _formKey,
          child: TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nome'), validator: (v) => v == null || v.isEmpty ? 'Insira o nome' : null),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
              await _service.updateCategory(_editingId!, _nameController.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir categoria'),
        content: const Text('Ao excluir, artigos com essa categoria permanecerão, mas sem vínculo. Deseja continuar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await _service.deleteCategory(id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Categoria excluída')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Gerenciar Categorias')),
        body: const Center(child: Text('Acesso restrito a administradores')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Categorias'),
        actions: [
          IconButton(onPressed: _startCreate, icon: const Icon(Icons.add)),
        ],
      ),
      body: StreamBuilder<List<Category>>(
        stream: _service.streamCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final categories = snapshot.data ?? [];
          if (categories.isEmpty) return const Center(child: Text('Nenhuma categoria disponível.'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return ListTile(
                title: Text(cat.name),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.edit), onPressed: () => _startEdit(cat.id, cat.name)),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _delete(cat.id)),
                ]),
              );
            },
          );
        },
      ),
    );
  }
}
