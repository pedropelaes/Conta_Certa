import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Widget MediumAppBar({
  required ThemeData theme,
  required TextTheme textTheme,
  required String title,
  required VoidCallback onSearch,
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