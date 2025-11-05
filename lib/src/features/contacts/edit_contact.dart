import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/models/user_model.dart';
import 'package:flutter_application_1/src/services/user_service.dart';
import 'package:flutter_application_1/src/settings/app_colors.dart';
import 'package:flutter_application_1/src/settings/app_dimensions.dart';
import 'package:flutter_application_1/src/settings/app_validators.dart';
import 'package:flutter_application_1/src/widgets/fields/inputs_text_fields.dart';

class EditContact extends StatefulWidget {
  final User user;

  const EditContact({super.key, required this.user});

  @override
  State<EditContact> createState() => _StateEditContact();
}

class _StateEditContact extends State<EditContact> {
  final UserService _userService = UserService();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _numberController = TextEditingController(text: widget.user.number);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _numberController.dispose();
    super.dispose();
  }

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
                    'Edit contact',
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
                prefixIconColor: AppColors.white,
                validator: AppValidators.email,
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
                validator: AppValidators.required,
                prefixIconColor: AppColors.white,
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

                        await _userService.updateUser(User(
                          id: widget.user.id,
                          name: _nameController.text,
                          email: _emailController.text,
                          number: _numberController.text,
                        ));

                        // Cerrar indicador de carga
                        if (context.mounted) Navigator.pop(context);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Contact updated successfully'),
                            ),
                          );
                          Navigator.pushNamed(context, '/');
                        }
                      } catch (e) {
                        // Cerrar indicador de carga
                        if (context.mounted) Navigator.pop(context);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error updating contact: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: AppDimensions.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.paddingSmall),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
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
                    try {
                      // Mostrar indicador de carga
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        ),
                      );

                      await _userService.deleteUser(widget.user.id);

                      // Cerrar indicador de carga
                      if (context.mounted) Navigator.pop(context);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Contact deleted successfully'),
                          ),
                        );
                        Navigator.pushNamed(context, '/');
                      }
                    } catch (e) {
                      // Cerrar indicador de carga
                      if (context.mounted) Navigator.pop(context);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error deleting contact: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Delete',
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
          side: BorderSide(
            color: AppColors.white,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(
            AppDimensions.borderRadiusLarge,
          ),
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
