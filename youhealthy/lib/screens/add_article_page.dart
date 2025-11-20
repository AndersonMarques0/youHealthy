import 'package:flutter/material.dart';
import 'package:youhealthy/models/artigo.dart';
import 'package:youhealthy/services/firestore_service.dart';

class AddArticlePage extends StatefulWidget {
  final Article? articleToEdit;

  const AddArticlePage({super.key, this.articleToEdit});

  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _authorController = TextEditingController();
  final _timeController = TextEditingController();
  final _imageController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedCategoryName;

  final _service = FirestoreService();

  @override
  void initState() {
    super.initState();
    if (widget.articleToEdit != null) {
      final a = widget.articleToEdit!;
      _titleController.text = a.title;
      _descriptionController.text = a.description;
      _authorController.text = a.author;
      _timeController.text = a.time;
      _imageController.text = a.image;
      _selectedCategoryName = a.tag;
    }
  }

  Future<void> _saveArticle() async {
    if (!_formKey.currentState!.validate()) return;

    final tagName = _selectedCategoryName ?? '';

    final newArticle = Article(
      id: widget.articleToEdit?.id ?? "",
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      author: _authorController.text.trim(),
      time: _timeController.text.trim(),
      image: _imageController.text.trim(),
      tag: tagName,
    );

    try {
      if (widget.articleToEdit == null) {
        await _service.addArticle(newArticle);
      } else {
        await _service.updateArticle(widget.articleToEdit!.id, newArticle);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.articleToEdit == null ? 'Artigo criado com sucesso!' : 'Artigo atualizado com sucesso!'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.articleToEdit != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Artigo' : 'Adicionar Artigo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Título'), validator: (v) => v!.isEmpty ? 'Insira o título' : null),
              TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Descrição'), maxLines: 3, validator: (v) => v!.isEmpty ? 'Insira a descrição' : null),
              TextFormField(controller: _authorController, decoration: const InputDecoration(labelText: 'Autor'), validator: (v) => v!.isEmpty ? 'Insira o autor' : null),
              TextFormField(controller: _timeController, decoration: const InputDecoration(labelText: 'Tempo de leitura'), validator: (v) => v!.isEmpty ? 'Insira o tempo' : null),
              TextFormField(controller: _imageController, decoration: const InputDecoration(labelText: 'URL da Imagem'), validator: (v) => v!.isEmpty ? 'Insira a URL' : null),

              const SizedBox(height: 16),
              StreamBuilder<List<Category>>(
                stream: _service.streamCategories(),
                builder: (context, snapshot) {
                  final categories = snapshot.data ?? [];
                  if (widget.articleToEdit != null && _selectedCategoryId == null && _selectedCategoryName != null && categories.isNotEmpty) {
                    final match = categories.firstWhere((c) => c.name == _selectedCategoryName, orElse: () => Category(id: '', name: ''));
                    if (match.id.isNotEmpty) _selectedCategoryId = match.id;
                  }

                  return DropdownButtonFormField<String>(
                    initialValue: _selectedCategoryId,
                    decoration: const InputDecoration(labelText: 'Categoria', border: OutlineInputBorder()),
                    items: categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                    onChanged: (catId) {
                      final cat = categories.firstWhere((c) => c.id == catId);
                      setState(() {
                        _selectedCategoryId = catId;
                        _selectedCategoryName = cat.name;
                      });
                    },
                    validator: (v) => v == null ? 'Escolha uma categoria' : null,
                  );
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveArticle, child: Text(isEditing ? 'Salvar Alterações' : 'Criar Artigo')),
            ],
          ),
        ),
      ),
    );
  }
}
