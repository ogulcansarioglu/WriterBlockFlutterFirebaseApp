import 'dart:async';
import 'dart:core';

import 'package:learningdart/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
      required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> Logout();
  Future<void> sendEmailVerification();
}


