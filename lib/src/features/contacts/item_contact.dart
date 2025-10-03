import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/user_model.dart';
import 'package:flutter_application_1/src/settings/app_colors.dart';
import 'package:flutter_application_1/src/settings/app_dimensions.dart';
import 'package:flutter_application_1/src/settings/app_string_custom_methods.dart';

class ItemContact extends StatelessWidget {
  const ItemContact({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
           Navigator.pushNamed(
          context,
          '/edit',
          arguments: user,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingSmall),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusLarge,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: AppColors.blueGrey,
                child: Text(
                  AppStringCustomMethods.getSiglasName(user.name),
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ),
            SizedBox(width: AppDimensions.paddingSmall),
            Text(
              user.name,
              style: TextStyle(
                fontSize: AppDimensions.fontSizeMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
