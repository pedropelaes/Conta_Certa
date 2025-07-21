import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Widget EventCard({
  required ThemeData theme,
  required TextTheme textTheme,
  required String title,
  required String description,
  required VoidCallback onOpenEvent,
  required VoidCallback onDelete,
}){
  return Padding(
    padding: const EdgeInsets.only(top: 10.0, left: 12, right: 12, bottom: 5),
    child: InkWell(
      onTap: onOpenEvent,
      borderRadius: BorderRadius.circular(25),
      child: Card(
        color: theme.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  PlatformIconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete, color: Colors.red, size: 36,),
                  )
                ],
              ),
              Text(
                description,
                textAlign: TextAlign.start,
                style: textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer
                ),
                maxLines: 5,
              )
            ],
          ),
        ),
      ),
    ),
  );
}