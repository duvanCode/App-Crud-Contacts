import 'dart:async';
import '../models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  
  factory UserService() {
    return _instance;
  }
  
  UserService._internal();
  
  final List<User> _users = [];
  
  final _usersController = StreamController<List<User>>.broadcast();
  
  Stream<List<User>> get usersStream => _usersController.stream;
  
  List<User> get users => List.unmodifiable(_users);
  
  void addUser(User user) {
    _users.add(user);
    _notifyListeners();
  }
  
  void updateUser(User updatedUser) {
    final index = _users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
      _notifyListeners();
    }
  }
  
  void deleteUser(String userId) {
    _users.removeWhere((user) => user.id == userId);
    _notifyListeners();
  }
  
  void _notifyListeners() {
    _usersController.add(users);
  }
  
  void dispose() {
    _usersController.close();
  }
}