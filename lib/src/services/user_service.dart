import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  // Referencia a la base de datos en tiempo real
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');

  // Stream que escucha cambios en tiempo real desde Firebase Realtime Database
  Stream<List<User>> get usersStream {
    return _usersRef.onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) {
        return <User>[];
      }

      final usersMap = data as Map<dynamic, dynamic>;
      return usersMap.entries.map((entry) {
        final userData = Map<String, dynamic>.from(entry.value as Map);
        return User.fromJson(userData);
      }).toList();
    });
  }

  // Obtener lista de usuarios (una sola vez)
  Future<List<User>> getUsers() async {
    try {
      final snapshot = await _usersRef.get();
      if (!snapshot.exists) {
        return [];
      }

      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.entries.map((entry) {
        final userData = Map<String, dynamic>.from(entry.value as Map);
        return User.fromJson(userData);
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener usuarios: $e');
    }
  }

  // Agregar usuario a Firebase
  Future<void> addUser(User user) async {
    try {
      await _usersRef.child(user.id).set(user.toJson());
    } catch (e) {
      throw Exception('Error al agregar usuario: $e');
    }
  }

  // Actualizar usuario en Firebase
  Future<void> updateUser(User updatedUser) async {
    try {
      await _usersRef.child(updatedUser.id).update(updatedUser.toJson());
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  // Eliminar usuario de Firebase
  Future<void> deleteUser(String userId) async {
    try {
      await _usersRef.child(userId).remove();
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }

  // Obtener un usuario específico por ID
  Future<User?> getUserById(String userId) async {
    try {
      final snapshot = await _usersRef.child(userId).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }

  // Buscar usuarios por nombre o email
  Future<List<User>> searchUsers(String query) async {
    try {
      final allUsers = await getUsers();
      return allUsers.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase()) ||
               user.email.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      throw Exception('Error al buscar usuarios: $e');
    }
  }
}