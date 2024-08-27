import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/database.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  // auth change user stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }


  Future<void> deleteUser(String passwordValue) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: passwordValue);
      try {
        await user.reauthenticateWithCredential(credential);
        await DatabaseService().deleteAccount();
        await user.delete();
        print("user deleted");
      } catch (e) {
        print("error: $e");
      }
    }
  }

  Future<bool> checkPassword(String oldPassword) async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: oldPassword);
        var authResult = await user.reauthenticateWithCredential(credential);
        return authResult != null;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> editPassword(String newPassword) async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "Successful";
    } on FirebaseAuthException catch (e) {
      print(e);
      return "error";
    }
  }
}
