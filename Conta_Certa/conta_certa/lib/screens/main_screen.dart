import 'package:conta_certa/screens/settings.dart';
import 'package:conta_certa/widgets/buttons.dart';
import 'package:conta_certa/widgets/cards.dart';
import 'package:conta_certa/widgets/dialogs.dart';
import 'package:conta_certa/widgets/slide_up_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:conta_certa/widgets/text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:conta_certa/models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EventsState extends ChangeNotifier {
  final List<Event> _events = [];
  List<Event> get events => List.unmodifiable(_events);

  EventsState(){
    loadEvents();
  }

  Future<void> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList("events") ?? [];
    _events.clear();
    _events.addAll(saved.map((e) => Event.fromJson(e)));
    notifyListeners();
  }

  Future<void> _saveEvents() async{
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _events.map((e) => e.toJson()).toList();
    await prefs.setStringList("events", jsonList);
  }

  void addEvent(String title, String description) async {
    _events.add(Event(title: title, description: description));
    await _saveEvents();
    notifyListeners();
  }

  void deleteEvent(int index) async{
    _events.removeAt(index);
    await _saveEvents();
    Fluttertoast.showToast(
      msg: 'Evento deletado.',
    );
    notifyListeners();
  }

}

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});
  
  @override 
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

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
              child: AddProductContainer(theme: theme, textTheme: textTheme, context: context, nameController: nameController, descriptionController: descriptionController),
              );
            }
          );
        },
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.add, size: 30, color: theme.colorScheme.onPrimary,),
      ),
      body: Consumer<EventsState>(
        builder: (context, eventsState, _) {
          return ListView(
            children: [
              Divider(
                thickness: 5,
                color: theme.colorScheme.secondary,
              ),
              ...eventsState.events.asMap().entries.map((entry) {
                final index = entry.key;
                final event = entry.value;
                return EventCard(
                  theme: theme,
                  textTheme: textTheme,
                  title: event.title,
                  description: event.description,
                  onDelete: () {
                    showPlatformDialog(
                      context: context,
                      builder: (_) => dialogDesign(
                        theme: theme, textTheme: textTheme, title: 'Deseja mesmo apagar ${event.title} ?', 
                        body: 'Não há reversão para essa ação. Todas as informações relacionadas a esse evento serão perdidas', 
                        confirm: 'Apagar', 
                        onConfirm: (){eventsState.deleteEvent(index);}, 
                        context: context
                      )
                    );
                  },
                  onOpenEvent: () {
                    print('Abrindo: ${event.title}');
                  },
                );
              })
            ],
          );
        },
      ),
    );
  }
}
Widget AddProductContainer({
  required ThemeData theme,
  required TextTheme textTheme,
  required BuildContext context,
  required TextEditingController nameController,
  required TextEditingController descriptionController,
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
              TextFieldDesign(theme: theme, textTheme: textTheme, hintText: "Nome do evento(obrigatório)", icon: Icons.edit, controller: nameController),
              TextFieldDesign(theme: theme, textTheme: textTheme, hintText: "Descrição do evento", icon: Icons.segment, controller: descriptionController),
              ButtonDesign(
                onPressed: (){
                  final navigator = Navigator.of(context);
                  final eventsState = Provider.of<EventsState>(context, listen: false);
                  eventsState.addEvent(nameController.text, descriptionController.text);
                  nameController.clear();
                  descriptionController.clear();
                  navigator.pop();
                },
                theme: theme, textTheme: textTheme, childText: "Criar"
              ),
            ],
          ),
        ),
      )
    );
}