import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/artigo.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Article>> streamArticles() {
    return _db.collection('articles').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Article.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> deleteArticle(String id) async {
    await _db.collection('articles').doc(id).delete();
  }

  Future<void> updateArticle(String id, Article updated) async {
    await _db.collection('articles').doc(id).update({
      'title': updated.title,
      'description': updated.description,
      'author': updated.author,
      'time': updated.time,
      'image': updated.image,
      'tag': updated.tag,
    });
  }

  Future<void> addArticle(Article article) async {
    await _db.collection('articles').add({
      'title': article.title,
      'description': article.description,
      'author': article.author,
      'time': article.time,
      'image': article.image,
      'tag': article.tag,
    });
  }
}
