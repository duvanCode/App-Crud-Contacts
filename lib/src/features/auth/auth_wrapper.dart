import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/auth/login_screen.dart';
import 'package:flutter_application_1/src/features/contacts/list_contacts.dart';
import 'package:flutter_application_1/src/services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Mientras se carga
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Si hay un usuario autenticado, mostrar la lista de contactos
        if (snapshot.hasData && snapshot.data != null) {
          return ListContacts();
        }

        // Si no hay usuario, mostrar login
        return const LoginScreen();
      },
    );
  }
}
