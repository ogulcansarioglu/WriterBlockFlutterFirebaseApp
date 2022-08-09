import 'package:learningdart/services/auth/auth_provider.dart';
import 'package:learningdart/services/auth/auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);
  
  @override
  Future<void> Logout() => provider.Logout();
  
  @override
  Future<AuthUser> createUser(
    {required String email, 
    required String password}) => 
    provider.createUser(email: email, password: password);
  
  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;
  
  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
  provider.logIn(email: email, password: password);

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}