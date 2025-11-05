import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/user_model.dart';
import 'package:flutter_application_1/src/services/user_service.dart';
import 'package:flutter_application_1/src/settings/app_colors.dart';
import 'package:flutter_application_1/src/settings/app_dimensions.dart';
import 'package:flutter_application_1/src/settings/app_validators.dart';
import 'package:flutter_application_1/src/widgets/fields/inputs_text_fields.dart';

class CreateContacts extends StatefulWidget {
  const CreateContacts({super.key});

  @override
  State<CreateContacts> createState() => _StateCreateContacts();
}

class _StateCreateContacts extends State<CreateContacts> {
  final UserService _userService = UserService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.fontSizeSmall),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New contact',
                    style: TextStyle(
                      fontSize: AppDimensions.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppColors.buttonBlue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              CustomTextField(
                hintText: 'Name',
                prefixIcon: Icon(Icons.person),
                prefixIconColor: AppColors.white,
                validator: AppValidators.required,
                widthBorder: 1,
                controller: _nameController,
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingSmall,
                ),
              ),
              SizedBox(height: AppDimensions.paddingSmall),
              CustomTextField(
                hintText: 'Mail',
                prefixIcon: Icon(Icons.mail),
                validator: AppValidators.email,
                prefixIconColor: AppColors.white,
                widthBorder: 1,
                controller: _emailController,
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingSmall,
                ),
              ),
              SizedBox(height: AppDimensions.paddingSmall),
              CustomTextField(
                hintText: 'Number',
                prefixIcon: Icon(Icons.phone),
                prefixIconColor: AppColors.white,
                validator: AppValidators.required,
                widthBorder: 1,
                controller: _numberController,
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingSmall,
                ),
              ),
              SizedBox(height: AppDimensions.paddingMedium),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBlue,
                    padding: EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusLarge,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        // Mostrar indicador de carga
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Center(
                            child: CircularProgressIndicator(
                              color: AppColors.buttonBlue,
                            ),
                          ),
                        );

                        await _userService.addUser(
                          User(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            name: _nameController.text,
                            email: _emailController.text,
                            number: _numberController.text,
                          ),
                        );

                        // Cerrar indicador de carga
                        if (context.mounted) Navigator.pop(context);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Contact created successfully')),
                          );
                          Navigator.pushNamed(context, '/');
                        }
                      } catch (e) {
                        // Cerrar indicador de carga
                        if (context.mounted) Navigator.pop(context);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error creating contact: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text(
                    'Create',
                    style: TextStyle(
                      fontSize: AppDimensions.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.white, width: 1.0),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
        backgroundColor: AppColors.inputBackground,
        child: Icon(Icons.close, color: AppColors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },
      ),
    );
  }
}
