import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_application_1/src/features/auth/auth_wrapper.dart';
import 'package:flutter_application_1/src/features/auth/login_screen.dart';
import 'package:flutter_application_1/src/features/auth/register_screen.dart';
import 'package:flutter_application_1/src/features/contacts/edit_contact.dart';
import 'package:flutter_application_1/src/features/contacts/create_contacts.dart';
import 'package:flutter_application_1/src/features/contacts/list_contacts.dart';
import 'package:flutter_application_1/src/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/edit') {
          final userToEdit = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) => EditContact(user: userToEdit),
          );
        }
        return null;
      },
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/contacts': (context) => ListContacts(),
        '/create': (context) => CreateContacts(),
      },
    );
  }
}
