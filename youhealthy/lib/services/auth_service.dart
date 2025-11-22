import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;

      if (user != null) {
        await _createUserDocument(user);
      }

      return user;
    } catch (e) {
      logger.e("Erro ao registrar: $e");
      rethrow;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return credential.user;
    } catch (e) {
      logger.e("Erro no login: $e");
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        await _createUserDocument(user);
      }

      return user;
    } catch (e) {
      logger.e("Erro no Google Sign-In: $e");
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<bool> isAdmin() async {
    final user = _auth.currentUser;

    if (user == null) {
      logger.w("isAdmin() → nenhum usuário logado");
      return false;
    }

    try {
      final doc = await _firestore.collection("users").doc(user.uid).get();

      if (!doc.exists) {
        logger.w("Documento não existe: users/${user.uid}");
        return false;
      }

      final isAdmin = doc.data()?['admin'] == true;

      logger.i("Usuário ${user.email} é admin? $isAdmin");
      return isAdmin;
    } catch (e) {
      logger.e("ERRO no isAdmin(): $e");
      return false;
    }
  }

  Future<void> _createUserDocument(User user) async {
    final ref = _firestore.collection("users").doc(user.uid);

    final doc = await ref.get();

    if (doc.exists) {
      logger.i("Usuário já existe no Firestore.");
      return;
    }

    await ref.set({
      "email": user.email,
      "admin": false, 
      "createdAt": FieldValue.serverTimestamp(),
    });

    logger.i("Documento do usuário criado em Firestore.");
  }

  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

}

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setAdmin(String uid, bool isAdmin) async {
    try {
      await _firestore.collection("users").doc(uid).set({
        "admin": isAdmin,
      }, SetOptions(merge: true));

      logger.i("Admin atualizado: $uid → $isAdmin");
    } catch (e) {
      logger.e("Erro ao alterar admin: $e");
    }
  }
}
