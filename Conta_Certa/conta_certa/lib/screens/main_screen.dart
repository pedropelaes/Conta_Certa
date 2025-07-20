import 'package:conta_certa/screens/settings.dart';
import 'package:conta_certa/widgets/buttons.dart';
import 'package:conta_certa/widgets/slide_up_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:conta_certa/widgets/text_field.dart';

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
        automaticallyImplyLeading: false,
        title: Row(
          children: [ Image.asset(
                'assets/images/conta_certa_logo.png',
                width: 60,
                height: 60,
                ),
            
            SizedBox(width: 5,),
            Expanded(
              child: Text(
                'Seus eventos',
                style: textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        actions: [
          PlatformIconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
              },
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(
            context: context, 
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            builder: (BuildContext context){
              return Padding(padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: AddProductContainer(theme: theme, textTheme: textTheme),
              );
            }
          );
        },
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

Widget AddProductContainer({
  required ThemeData theme,
  required TextTheme textTheme,
}){
    return SlideUpContainer(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        color: theme.colorScheme.secondaryContainer,
        margin: EdgeInsets.only(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 15,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Adicionando evento',
                textAlign: TextAlign.left,
                style: textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                )
              ),
              TextFieldDesign(theme: theme, textTheme: textTheme, hintText: "Nome do evento(obrigatório)", icon: Icons.edit),
              TextFieldDesign(theme: theme, textTheme: textTheme, hintText: "Descrição do evento", icon: Icons.segment),
              ButtonDesign(theme: theme, textTheme: textTheme, childText: "Criar")
            ],
          ),
        ),
      )
    );
}