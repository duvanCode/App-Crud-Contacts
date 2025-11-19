import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  String get _baseUrl => 'http://165.154.245.7:5151';
  String get _apiPath => '$_baseUrl/api/usuarios';

  final StreamController<List<User>> _usersStreamController =
      StreamController<List<User>>.broadcast();

  Stream<List<User>> get usersStream => _usersStreamController.stream;

  List<User>? _cachedUsers;
  bool _isLoading = false;

  void _handleResponse(http.Response response, String operation) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Error al $operation: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<User>> getUsers() async {
    if (_isLoading) return _cachedUsers ?? [];
    
    _isLoading = true;
    try {
      print('🔄 Fetching users from: $_apiPath');
      
      final response = await http.get(
        Uri.parse(_apiPath),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('La conexión tardó demasiado');
        },
      );

      print('✅ Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      _handleResponse(response, 'obtener usuarios');

      final decoded = json.decode(response.body);
      
      // Manejar diferentes formatos de respuesta
      List<dynamic> data;
      if (decoded is List) {
        data = decoded;
      } else if (decoded is Map && decoded.containsKey('data')) {
        data = decoded['data'];
      } else {
        throw Exception('Formato de respuesta inesperado');
      }

      final users = data.map((json) => User.fromJson(json)).toList();
      
      _cachedUsers = users;
      _usersStreamController.add(users);

      print('✅ Users loaded: ${users.length}');
      return users;
    } catch (e) {
      print('❌ Error getting users: $e');
      // Emitir lista vacía en caso de error para no dejar el stream esperando
      _usersStreamController.add([]);
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> addUser(User user) async {
    try {
      print('➕ Adding user: ${user.name}');
      
      final response = await http.post(
        Uri.parse(_apiPath),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      ).timeout(const Duration(seconds: 10));

      print('✅ Add response: ${response.statusCode}');

      _handleResponse(response, 'agregar usuario');

      await getUsers();
    } catch (e) {
      print('❌ Error adding user: $e');
      throw Exception('Error al agregar usuario: $e');
    }
  }

  Future<void> updateUser(User updatedUser) async {
    try {
      print('✏️ Updating user: ${updatedUser.id}');
      
      final response = await http.put(
        Uri.parse('$_apiPath/${updatedUser.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedUser.toJson()),
      ).timeout(const Duration(seconds: 10));

      print('✅ Update response: ${response.statusCode}');

      _handleResponse(response, 'actualizar usuario');

      await getUsers();
    } catch (e) {
      print('❌ Error updating user: $e');
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      print('🗑️ Deleting user: $userId');
      
      final response = await http.delete(
        Uri.parse('$_apiPath/$userId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('✅ Delete response: ${response.statusCode}');

      _handleResponse(response, 'eliminar usuario');

      await getUsers();
    } catch (e) {
      print('❌ Error deleting user: $e');
      throw Exception('Error al eliminar usuario: $e');
    }
  }

  Future<User?> getUserById(String userId) async {
    try {
      print('🔍 Getting user by ID: $userId');
      
      final response = await http.get(
        Uri.parse('$_apiPath/$userId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 404) {
        print('⚠️ User not found: $userId');
        return null;
      }

      _handleResponse(response, 'obtener usuario');

      final decoded = json.decode(response.body);
      final data = decoded is Map && decoded.containsKey('data') 
          ? decoded['data'] 
          : decoded;
          
      return User.fromJson(data);
    } catch (e) {
      print('❌ Error getting user by ID: $e');
      throw Exception('Error al obtener usuario: $e');
    }
  }

  Future<List<User>> searchUsers(String query) async {
    try {
      print('🔎 Searching users: $query');
      
      final response = await http.get(
        Uri.parse('$_apiPath/search/$query'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      _handleResponse(response, 'buscar usuarios');

      final decoded = json.decode(response.body);
      final List<dynamic> data = decoded is List ? decoded : decoded['data'];
      
      return data.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error searching users: $e');
      throw Exception('Error al buscar usuarios: $e');
    }
  }

  Future<void> refreshUsers() async {
    await getUsers();
  }

  void dispose() {
    _usersStreamController.close();
  }
}