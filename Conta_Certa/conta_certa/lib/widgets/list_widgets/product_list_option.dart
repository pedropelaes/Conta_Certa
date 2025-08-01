import 'package:conta_certa/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Widget buildProductOption({
    required ThemeData theme,
    required TextTheme textTheme,
    required BuildContext context,
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
    required String nome,
}){
  if(isIOSPlatform(context)){
    return InkWell(
      onTap: (){onChanged(!isChecked);},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.shopping_bag_outlined, color: theme.colorScheme.onSecondaryContainer,),
            Expanded(
              child: Text(
                nome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer
                ),
              ),
            ),
            if(isChecked) Icon(Icons.check_rounded, color: theme.colorScheme.onPrimaryContainer),
          ],
        ),
      ),
    );
  }else{
    return ListTile(
      title: Row(
        children: [
          Icon(Icons.shopping_bag_outlined, color: theme.colorScheme.onSecondaryContainer, size: 30,),
          Expanded(
            child: Text(
              nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSecondaryContainer
              ),
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