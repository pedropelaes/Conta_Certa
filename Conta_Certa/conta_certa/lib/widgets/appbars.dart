import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Widget MediumAppBar({
  required ThemeData theme,
  required TextTheme textTheme,
  required String title,
  required VoidCallback onSearch,
  bool hasSearch = true
}){
  return SliverAppBar.medium(
    title: Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        title,
        style: textTheme.headlineLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
    ),
    actions: [
      if(hasSearch)
      PlatformIconButton(
      onPressed: onSearch,
      icon: Icon(
        Icons.search,
        size: 30,
      ),
    ),
  ],
  );
}