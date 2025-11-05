import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/services/auth_service.dart';
import 'package:flutter_application_1/src/settings/app_colors.dart';
import 'package:flutter_application_1/src/settings/app_dimensions.dart';
import 'package:flutter_application_1/src/settings/app_string_custom_methods.dart';
import 'package:flutter_application_1/src/widgets/fields/inputs_text_fields.dart';

class SearchFrom extends StatefulWidget {
  final String userName;
  final Function(String)? onSearchChanged;

  const SearchFrom({
    super.key,
    required this.userName,
    this.onSearchChanged,
  });

  @override
  State<SearchFrom> createState() => _SearchFromState();
}

class _SearchFromState extends State<SearchFrom> {
  final TextEditingController _searchController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el campo de búsqueda
    _searchController.addListener(() {
      if (widget.onSearchChanged != null) {
        widget.onSearchChanged!(_searchController.text);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.inputBackground,
          title: Text(
            'Cerrar Sesión',
            style: TextStyle(color: AppColors.white),
          ),
          content: Text(
            '¿Estás seguro de que quieres cerrar sesión?',
            style: TextStyle(color: AppColors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppColors.blueGrey),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(color: AppColors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _authService.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomTextField(
            controller: _searchController,
            hintText: 'Search contact',
            prefixIcon: Icon(Icons.search),
            prefixIconColor: AppColors.white,
            widthBorder: 1,
            contentPadding: EdgeInsets.symmetric(
              vertical: AppDimensions.paddingSmall,
            ),
          ),
        ),
        SizedBox(width: AppDimensions.paddingSmall),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'logout') {
              _handleLogout();
            }
          },
          color: AppColors.inputBackground,
          offset: Offset(0, 50),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: AppColors.red, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Cerrar Sesión',
                    style: TextStyle(color: AppColors.white),
                  ),
                ],
              ),
            ),
          ],
          child: Container(
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
                AppStringCustomMethods.getSiglasName(widget.userName),
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
