import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/contacts/edit_contact.dart';
import 'package:flutter_application_1/src/features/contacts/create_contacts.dart';
import 'package:flutter_application_1/src/features/contacts/list_contacts.dart';
import 'package:flutter_application_1/src/models/user_model.dart';

void main() {
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
        '/': (context) => ListContacts(),
        '/create': (context) => CreateContacts(),
      }
    );
  }
}
