import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/contacts/item_contact.dart';
import 'package:flutter_application_1/src/services/user_service.dart';
import 'package:flutter_application_1/src/settings/app_colors.dart';
import 'package:flutter_application_1/src/settings/app_dimensions.dart';
import 'package:flutter_application_1/src/features/contacts/search_contacts.dart';

class ListContacts extends StatelessWidget {
  ListContacts({super.key});

  UserService _userService = UserService();
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.fontSizeSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: AppDimensions.paddingExtraLarge),
            SearchFrom(userName: 'Duvan Yair'),
            SizedBox(height: AppDimensions.paddingMedium),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 10,
                    children: _userService.users.map((user) => ItemContact(user: user)).toList(),
                  ),
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
