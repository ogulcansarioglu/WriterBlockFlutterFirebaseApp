import 'package:firebase_auth/firebase_auth.dart' as FireBaseAuth show User;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
final String? email;
final bool isEmailVerified;
const AuthUser({required this.email,
 required this.isEmailVerified,});

factory AuthUser.fromFirebase(User user) => AuthUser(email: user.email, isEmailVerified: user.emailVerified);


}

