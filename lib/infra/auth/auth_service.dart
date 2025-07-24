import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String userEmailKey = 'userEmail';
  static const String userPasswordKey = 'userPassword';
  static const String emailSuffix = '@peacely.com';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<User> signInWithEmailAndPassword(
    String? email,
    String? password,
  ) async {
    if (email == null || password == null) {
      throw Exception('Email e senha não podem ser nulos.');
    }

    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: '$email$emailSuffix',
      password: password,
    );

    if (userCredential.user == null) {
      throw Exception('Usuário não encontrado.');
    }

    await _secureStorage.write(key: userEmailKey, value: email);

    await _secureStorage.write(key: userPasswordKey, value: password);

    return userCredential.user!;
  }

  Future<String> createResidentUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: '$email$emailSuffix',
      password: password,
    );

    await signInWithEmailAndPassword(
      await _secureStorage.read(key: userEmailKey),
      await _secureStorage.read(key: userPasswordKey),
    );

    if (userCredential.user == null) {
      throw Exception('Usuário não encontrado.');
    }

    return userCredential.user!.uid;
  }

  User? get currentUser => _auth.currentUser;
  static AuthService instance = AuthService();
}
