import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/artigo.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createDocument(String collection, Map<String, dynamic> data) async {
    await _db.collection(collection).add(data);
  }

  Stream<QuerySnapshot> readCollection(String collection) {
    return _db.collection(collection).snapshots();
  }

  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteDocument(String collection, String docId) async {
    await _db.collection(collection).doc(docId).delete();
  }

  Future<List<Article>> getArticles() async {
    try {
      final snapshot = await _db.collection('articles').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Article(
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          author: data['author'] ?? '',
          time: data['time'] ?? '',
          image: data['image'] ?? '',
          tag: data['tag'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar artigos: $e');
    }
  }
}
