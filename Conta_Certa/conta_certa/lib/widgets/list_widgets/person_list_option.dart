import 'package:conta_certa/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Widget buildPersonOption({
    required ThemeData theme,
    required TextTheme textTheme,
    required BuildContext context,
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
    required String nome,
    required String value,
}){
  if(isIOSPlatform(context)){
    return InkWell(
      onTap: (){onChanged(!isChecked);},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              spacing: 5,
              children: [
                Icon(Icons.account_circle_rounded, color: theme.colorScheme.onSecondaryContainer, size: 30,),
                Expanded(
                  child: Text(
                    nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                      decorationColor: theme.colorScheme.onSecondaryContainer,
                      decorationThickness: 2,
                      fontFamily: 'Inter'
                    ),
                  ),
                ),
                if(isChecked) Icon(Icons.check_rounded, color: theme.colorScheme.onPrimaryContainer),
              ],
            ),
            Text(
              value,
              style: textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                decoration: isChecked ? TextDecoration.lineThrough : null,
                decorationColor: theme.colorScheme.onSecondaryContainer,
                decorationThickness: 2,
                fontFamily: 'Inter'
              ),
            ),
          ],
        ),
      ),
    );
  }else{
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 5,
            children: [
              Icon(Icons.account_circle_rounded, color: theme.colorScheme.onSecondaryContainer, size: 30,),
              Expanded(
                child: Text(
                  nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                    decorationColor: theme.colorScheme.onSecondaryContainer,
                    decorationThickness: 2,
                    fontFamily: 'Inter'
                  ),
                ),
              ),
            ],
          ),
          Text(
              value,
              style: textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                decoration: isChecked ? TextDecoration.lineThrough : null,
                decorationColor: theme.colorScheme.onSecondaryContainer,
                decorationThickness: 2,
                fontFamily: 'Inter'
              ),
            ),
        ],
      ),
      trailing: PlatformCheckbox(
        value: isChecked,
        onChanged: onChanged,
      ),
      onTap: (){onChanged(!isChecked);},
    );
  }
}