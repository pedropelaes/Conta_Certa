import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Widget ButtonDesign({
  required ThemeData theme,
  required TextTheme textTheme,
  required String childText,
  required VoidCallback onPressed
}){
  return PlatformElevatedButton(
    onPressed: onPressed,
    color: theme.colorScheme.onSecondaryContainer,
    child: Text(
      childText,
      style: textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.onPrimary
      ),
    ),
  );
}