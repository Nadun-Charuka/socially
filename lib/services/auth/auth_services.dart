import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socially/services/user/user_services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = UserService();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> registerWithEmail(
      String email, String password, String name) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = result.user;

    if (user != null) {
      await _userService.createUserProfile(user, name, false);
    }

    return user;
  }

  Future<User?> loginWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<User?> loginWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _auth.signInWithCredential(credential);
    final user = result.user;

    if (user != null) {
      await _userService.createUserProfile(
          user, user.displayName ?? 'Google User', true);
    }

    return user;
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
