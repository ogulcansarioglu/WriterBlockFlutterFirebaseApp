//login exceptions

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//register exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUsedAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//generic exception

class GenericAuthException implements Exception {}

class UserNotLoggedInException implements Exception {}


