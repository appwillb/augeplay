import 'package:flutter/foundation.dart';
import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/auth/domain/models/user_role.dart';
import 'package:playauge/features/auth/domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._repository) {
    _loadInitialUser();
  }

  UserEntity? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _loadInitialUser() async {
    _currentUser = await _repository.getCurrentUser();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _repository.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String stageName,
    required String email,
    required String password,
    required String city,
    required String state,
    required String bio,
    required List<UserRole> roles,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _repository.register(
        name: name,
        stageName: stageName,
        email: email,
        password: password,
        city: city,
        state: state,
        bio: bio,
        roles: roles,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> updateCurrentUser(UserEntity user) async {
    _currentUser = await _repository.updateCurrentUser(user);
    notifyListeners();
  }

  Future<void> logout() async {
    await _repository.logout();
    _currentUser = null;
    notifyListeners();
  }
}
