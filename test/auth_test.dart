import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:learningdart/services/auth/auth_exceptions.dart';
import 'package:learningdart/services/auth/auth_provider.dart';
import 'package:learningdart/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });
    test('Connat log out if not initialized', () {
    expect(
      provider.Logout(), 
      throwsA(const TypeMatcher<NotInitiliazedException>())
      );

    });

    test('Should be a ble to initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

     test('Should not be null', () {
      
      expect(provider.currentUser, false);
    });

    test('Should be able to initialize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    },
    timeout:const Timeout(Duration(seconds:2)),
    );
     test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com', 
        password: 'asd');
      expect(badEmailUser, 
        throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final user = await provider.createUser(
        email: 'foo', 
        password: 'foo');
        expect(provider.currentUser, user);
        expect(user.isEmailVerified, false);
    });

      test('Login user should be able to get verified', () {
        provider.sendEmailVerification();
        final user = provider.currentUser;
        expect(user, isNotNull);
        expect(user!.isEmailVerified, true);

      });

      test('Should be able to log out and log in again', () async {
        await provider.Logout();
        await provider.logIn(
          email: 'email', 
          password: 'password');
        final user = provider.currentUser;
        expect(user, isNotNull);
      });
      
  });
    
   

}

class NotInitiliazedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<void> Logout() async{
    if (!isInitialized) throw NotInitiliazedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialized) throw NotInitiliazedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize()  async{
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    // change for real logic when implemented
    if (!isInitialized) throw NotInitiliazedException();
    if(email == 'foo@bar.com') throw UserNotFoundAuthException();
    if(password == "foobar") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitiliazedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
