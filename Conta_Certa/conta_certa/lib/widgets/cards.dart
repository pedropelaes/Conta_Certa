import 'package:conta_certa/screens/people_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Widget BaseCard({
  required ThemeData theme,
  required TextTheme textTheme,
  required VoidCallback onOpen,
  required List<Widget> content,
}){
  return  Padding(
    padding: const EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 5),
    child: InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(25),
      child: Card(
        color: theme.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: content,
          ),
        ),
      ),
    ),
  );
}

Widget EventCard({
  required ThemeData theme,
  required TextTheme textTheme,
  required String title,
  required String description,
  required VoidCallback onOpenEvent,
  required VoidCallback onDelete,
}){
  return BaseCard(
      theme: theme,
      textTheme: textTheme,
      onOpen: onOpenEvent,
      content: [
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
      ]
    );
}

Widget PersonCard({
  required ThemeData theme,
  required TextTheme textTheme,
  required String name,
  required VoidCallback onDelete,
  required VoidCallback onEdit,
  required VoidCallback onAdd,
  required VoidCallback onOpen,
  required BuildContext context,
  bool isBuyer = false,
}){
  final icon = isBuyer ? Icons.attach_money_rounded : Icons.account_circle_rounded;
  final action = isBuyer ? onOpen : onAdd;
  return BaseCard(
    theme: theme, 
    textTheme: textTheme, 
    onOpen: action, 
    content: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(icon, color: theme.colorScheme.onPrimaryContainer, size: 30,),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlatformIconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete, color: Colors.red, size: 40,),
                  ),
                  PlatformIconButton(
                    onPressed: onEdit,
                    icon: Icon(Icons.edit_outlined, color: theme.colorScheme.onPrimaryContainer, size: 36,),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          PlatformIconButton(
            onPressed: onAdd,
            icon: Icon(Icons.add_circle_outline, color: theme.colorScheme.onPrimaryContainer, size: 44,),
          ),
          if(isBuyer)
          Icon(Icons.arrow_right, color: theme.colorScheme.onPrimaryContainer, size: 44,)
        ],
      ),
      
    ]
  );
}

Widget ProductCard ({
  required BuildContext context,
  required ThemeData theme,
  required TextTheme textTheme,
  required VoidCallback onOpen,
  required VoidCallback onDelete,
  required VoidCallback onEdit,
  required String name,
  required String value,
}){
  return BaseCard(
    theme: theme, 
    textTheme: textTheme, 
    onOpen: onOpen, 
    content: [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer
                ),
              ),
            ),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
            children: [
              PlatformIconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete, color: Colors.red, size: 40,),
              ),
              PlatformIconButton(
                onPressed: onEdit,
                icon: Icon(Icons.edit_outlined, color: theme.colorScheme.onPrimaryContainer, size: 36,),
              ),
              Spacer(),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
                child: Text(
                  'R\$$value',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.displaySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              )
            ],
      )
    ]
  );
}

Widget ValueCard({
  required ThemeData theme,
  required TextTheme textTheme,
  required BuildContext context,
  required String title,
  required String value,
}){
  final cardColor = title == 'Valor total:'? theme.colorScheme.tertiaryContainer : theme.colorScheme.primaryContainer; 
  final textColor = title == 'Valor total:'? theme.colorScheme.onTertiaryContainer: theme.colorScheme.onPrimaryContainer;
  return Card(
    color: cardColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.37,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: textTheme.titleLarge?.copyWith(
                color: textColor,
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.left,
                style: textTheme.displaySmall?.copyWith(
                  fontFamily: 'Inter',
                  color: textColor,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget FinancialListCard({
  required ThemeData theme,
  required TextTheme textTheme,
  required BuildContext context,
}){
  return Card(
    color: theme.colorScheme.secondaryContainer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Pessoa',
                  style: textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                Text(
                  'Já pagou',
                  style: textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
            listDivider(theme: theme),

          ],
        ),
      ),
    ),
  );
}