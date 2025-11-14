import 'package:cloud_firestore/cloud_firestore.dart';

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
}
