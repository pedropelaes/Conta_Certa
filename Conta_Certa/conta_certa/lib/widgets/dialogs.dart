import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Widget dialogDesign ({
  required ThemeData theme,
  required TextTheme textTheme,
  required String title,
  required String body,
  required String confirm,
  required VoidCallback onConfirm,
  required BuildContext context
}){
  final confirmColor = (confirm == 'Apagar') ? theme.colorScheme.error : theme.colorScheme.primary;
  return PlatformAlertDialog(
    title: Text(
      title,
      style: (Platform.isIOS
        ? textTheme.headlineMedium
        : textTheme.headlineLarge
      )?.copyWith(
        color: theme.colorScheme.onSurface
      ),
    ),
    content: Text(
      body,
      style: textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurfaceVariant
      ),
    ),
    material: (_, __) => MaterialAlertDialogData(
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
    ),
    actions: [
      if(confirm == 'Apagar')
        PlatformDialogAction(
          child: Text(
            'Cancelar',
            style: textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      
      PlatformDialogAction(
        child: Text(
          confirm,
          style: textTheme.bodyMedium?.copyWith(
            color: confirmColor
          ),
        ),
        onPressed: (){
          Navigator.pop(context);
          onConfirm();
        },
        cupertino: (_, __) => CupertinoDialogActionData(
          isDestructiveAction: true
        ),
      )
    ],
  );
}