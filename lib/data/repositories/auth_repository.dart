import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authState() => _auth.authStateChanges();
  Future<User?> createUser(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return result.user;
  }
  Future<User?> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return result.user;
  }

  Future<void> signOut() => _auth.signOut();
}