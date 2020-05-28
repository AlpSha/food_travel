
abstract class AuthenticationRepository {
  Future<void> authenticate();

  Future<bool> get isAuthenticated;

  Future<String> get authenticatedUserId;

  Future<void> logOut();

}
