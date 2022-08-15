import 'package:firebase_auth/firebase_auth.dart' as FireBaseAuth show User;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
final bool isEmailVerified;
const AuthUser({required this.isEmailVerified});

factory AuthUser.fromFirebase(User user) => AuthUser(isEmailVerified: user.emailVerified);


}

