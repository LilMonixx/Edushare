class AuthUserSession {
  final String uid;
  final String email;
  final String name;
  final String accessToken;

  AuthUserSession({
    required this.uid,
    required this.email,
    required this.name,
    required this.accessToken,
  });
}