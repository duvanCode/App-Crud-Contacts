import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/contacts/item_contact.dart';
import 'package:flutter_application_1/src/models/user_model.dart';
import 'package:flutter_application_1/src/services/auth_service.dart';
import 'package:flutter_application_1/src/services/user_service.dart';
import 'package:flutter_application_1/src/settings/app_colors.dart';
import 'package:flutter_application_1/src/settings/app_dimensions.dart';
import 'package:flutter_application_1/src/features/contacts/search_contacts.dart';

class ListContacts extends StatefulWidget {
  ListContacts({super.key});

  @override
  State<ListContacts> createState() => _ListContactsState();
}

class _ListContactsState extends State<ListContacts> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  String _searchQuery = '';



    @override
    void initState() {
      super.initState();
      _userService.getUsers();
    }

    
  @override
  Widget build(BuildContext context) {
    final currentUserEmail = _authService.currentUser?.email ?? 'Usuario';




    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.fontSizeSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: AppDimensions.paddingExtraLarge),
            SearchFrom(
              userName: currentUserEmail,
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query.toLowerCase();
                });
              },
            ),
            SizedBox(height: AppDimensions.paddingMedium),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: StreamBuilder<List<User>>(
                  stream: _userService.usersStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.buttonBlue,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 60,
                            ),
                            SizedBox(height: AppDimensions.paddingMedium),
                            Text(
                              'Error loading contacts',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppDimensions.fontSizeMedium,
                              ),
                            ),
                            Text(
                              '${snapshot.error}',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: AppDimensions.fontSizeSmall,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    // Filtrar usuarios según búsqueda
                    final allUsers = snapshot.data ?? [];
                    final users = _searchQuery.isEmpty
                        ? allUsers
                        : allUsers.where((user) {
                            return user.name.toLowerCase().contains(_searchQuery) ||
                                   user.email.toLowerCase().contains(_searchQuery) ||
                                   (user.number?.toLowerCase().contains(_searchQuery) ?? false);
                          }).toList();

                    if (users.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchQuery.isEmpty
                                  ? Icons.contacts_outlined
                                  : Icons.search_off,
                              color: AppColors.white.withOpacity(0.5),
                              size: 80,
                            ),
                            SizedBox(height: AppDimensions.paddingMedium),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No contacts yet'
                                  : 'No contacts found',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppDimensions.fontSizeMedium,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: AppDimensions.paddingSmall),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'Add your first contact'
                                  : 'Try a different search',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.7),
                                fontSize: AppDimensions.fontSizeSmall,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Mostrar lista de usuarios
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 10,
                        children: users.map((user) => ItemContact(user: user)).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.inputBackground,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.white, width: 1.0),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
        child: Icon(Icons.person_add_alt_rounded, color: AppColors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        },
      ),
    );
  }
}
