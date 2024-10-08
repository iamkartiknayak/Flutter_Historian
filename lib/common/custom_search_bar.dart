import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:historian/app_theme.dart';

class CustomSearchBox extends StatelessWidget {
  const CustomSearchBox({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
  });

  final String hintText;
  final TextEditingController controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final borderRadius = Theme.of(context).extension<BorderRadiusTheme>();

    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(60),
        borderRadius: BorderRadius.circular(borderRadius!.categoryTwoRadius),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: true,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
              fontSize: 18.0,
            ),
        decoration: InputDecoration(
          border: InputBorder.none,
          alignLabelWithHint: true,
          hintStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w200,
            color: isLightTheme ? Colors.grey.shade700 : Colors.grey.shade400,
          ),
          hintText: hintText,
          contentPadding: const EdgeInsets.only(top: 12.0),
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
            child: SvgPicture.asset(
              'assets/svgs/search.svg',
              colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
