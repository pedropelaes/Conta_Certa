
import 'package:flutter/material.dart';

Widget TextFieldDesign({
  required ThemeData theme,
  required TextTheme textTheme,
  required String hintText,
  required IconData icon
}){
return TextField(
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: theme.colorScheme.onSecondaryContainer,),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: theme.colorScheme.onSecondaryContainer, strokeAlign: 3)
      ),
    ),
    style: textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.onSecondaryContainer
    ),
  );
}