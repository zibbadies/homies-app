class AuthState {
  final bool isAuthenticated;
  final String? token;

  const AuthState({this.isAuthenticated = false, this.token});
}
