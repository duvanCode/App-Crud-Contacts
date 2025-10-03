import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/settings/app_colors.dart';
import 'package:flutter_application_1/src/settings/app_dimensions.dart';
import 'package:flutter_application_1/src/settings/app_string_custom_methods.dart';
import 'package:flutter_application_1/src/widgets/fields/inputs_text_fields.dart';

class SearchFrom extends StatefulWidget {
  final String userName;
  const SearchFrom({super.key, required this.userName});

  @override
  State<SearchFrom> createState() => _SearchFromState();
}

class _SearchFromState extends State<SearchFrom> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext contenxt) {
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
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          splashColor: AppColors.overlayColor,
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
