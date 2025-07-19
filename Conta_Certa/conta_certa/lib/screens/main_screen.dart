import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class EventsState extends ChangeNotifier {

}

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override 
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
  

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Row(
          children: [
            Image.asset(
              'assets/images/conta_certa_logo.png',
              width: 60,
              height: 60,
              ),
            SizedBox(width: 5,),
            Text(
              'Seus eventos',
              style: textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            Spacer(flex: 3,),
            PlatformIconButton(
              onPressed: (){},
              icon: Icon(
                Icons.settings,
                size: 30,
              ),
            ),
            SizedBox(width: 12,),
            PlatformIconButton(
              onPressed: (){},
              icon: Icon(
                Icons.search,
                size: 30,
              ),
            ),
            SizedBox(width: 8,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.add, size: 30, color: theme.colorScheme.onPrimary,),
      ),
      body: Center(
        child: Column(
          children: [
            Divider(
              thickness: 5,
              color: theme.colorScheme.secondary,
            )
          ],
        ),
      ),
    );
  }
}