// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Mevcut kullanıcıyı dinlemek için Stream
  Stream<User?> get user => _auth.authStateChanges();

  // Google ile Giriş Yapma
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Google Sign-In sürecini başlat
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Kullanıcı pencereyi kapattı
        return null;
      }

      // Google'dan kimlik doğrulama detaylarını al
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Firebase için bir kimlik bilgisi (credential) oluştur
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase'e giriş yap ve kullanıcı bilgilerini döndür
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      // Hata yönetimi
      print("Google ile giriş hatası: $e");
      return null;
    }
  }

  // Çıkış Yapma
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}