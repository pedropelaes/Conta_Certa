import 'package:conta_certa/models/event.dart';
import 'package:conta_certa/models/people.dart';
import 'package:conta_certa/widgets/buttons.dart';
import 'package:conta_certa/widgets/cards.dart';
import 'package:conta_certa/widgets/dialogs.dart';
import 'package:conta_certa/widgets/slide_up_container.dart';
import 'package:conta_certa/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeopleState extends ChangeNotifier{
  final Event event;

  PeopleState(this.event){
    _loadEventFromStorage();
  }

  List<Pessoa> get pessoas => List.unmodifiable(event.people);

  void addPessoa (String nome){
    event.people.add(Pessoa(nome: nome));
    saveEventToStorage();
    notifyListeners();
  }

  void editPessoa(int index, String newName){
    event.people[index].nome = newName;
    saveEventToStorage();
    notifyListeners();
    Fluttertoast.showToast(
      msg: "Pessoa atualizada.",
    );
  }

  void deletePessoa (int index){
    event.people.removeAt(index);
    saveEventToStorage();
    notifyListeners();
    Fluttertoast.showToast(
      msg: "Pessoa deletada.",
    );
  }
  
  void saveEventToStorage() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(event.title, event.toJson());
  }

  Future<void> _loadEventFromStorage() async{
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(event.title);

    if(jsonString != null){
      try{
        Event loadedEvent = Event.fromJson(jsonString);
        event.people
          ..clear()
          ..addAll(loadedEvent.people);
        notifyListeners();
      } catch (e){
        Fluttertoast.showToast(msg: "Erro: $e");
        print("Erro ao carregar evento: $e");
      }
    }
  }
}

class PeopleScreen extends StatefulWidget {
  final Event event;
  
  const PeopleScreen({super.key, required this.event});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Consumer<PeopleState>(
      builder: (context, peopleState, _) {
        // Proper sliver implementation
        if (peopleState.pessoas.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Text("Você ainda não adicionou nenhuma pessoa, elas aparecerão aqui.", style: textTheme.bodyLarge, textAlign: TextAlign.center,),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final person = peopleState.pessoas[index];
              return PersonCard(
                theme: theme,
                textTheme: textTheme,
                name: person.nome ?? "Unnamed",
                onDelete: () { 
                  showPlatformDialog(
                      context: context,
                      builder: (_) => dialogDesign(
                        theme: theme, textTheme: textTheme, title: 'Deseja mesmo apagar ${person.nome} ?', 
                        body: 'Não há reversão para essa ação. Todas as informações relacionadas a essa pessoa serão perdidas', 
                        confirm: 'Apagar', 
                        onConfirm: (){peopleState.deletePessoa(index);}, 
                        context: context
                      )
                    );
                },
                onEdit: () => showEditPerson(context, widget.event, index, peopleState),
                onAdd: () {
                  if(peopleState.event.produtos.isEmpty){
                    showPlatformDialog(
                      context: context,
                      builder: (_) => dialogDesign(
                        theme: theme,
                        textTheme: textTheme,
                        title: 'Não há produtos criados',
                        body: 'Para relacionar um produto com uma pessoa, é preciso antes ter criado produtos.',
                        confirm: 'Confirmar',
                        onConfirm: () {},
                        context: context,
                      )
                    );
                  }else{
                    showModalBottomSheet(
                      context: context, 
                      builder: (_) => AddConsumedProductContainer(theme: theme, textTheme: textTheme, context: context, peopleState: peopleState)
                    );
                  }
                },
                context: context
              );
            },
            childCount: peopleState.pessoas.length,
          ),
        );
      },
    );
  }
}
Widget AddPersonContainer({
  required ThemeData theme,
  required TextTheme textTheme,
  required BuildContext context,
  required TextEditingController nameController,
  required Event event,
  required PeopleState peopleState
}){
  return SlideUpContainer(
    content: [
      Text(
        'Adicionando pessoa',
        style: textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      TextFieldDesign(theme: theme, textTheme: textTheme, hintText: 'Nome da pessoa', icon: Icons.account_circle_outlined, controller: nameController),
      ButtonDesign(theme: theme, textTheme: textTheme, childText: 'Adicionar', onPressed: (){
        final navigator = Navigator.of(context);
        peopleState.addPessoa(nameController.text);
        nameController.clear();
        navigator.pop();
      }),
    ], 
    theme: theme
  );
}

Widget EditPersonContainer({
  required ThemeData theme,
  required TextTheme textTheme,
  required BuildContext context,
  required TextEditingController nameController,
  required Event event,
  required int index,
  required PeopleState peopleState
}){
  return SlideUpContainer(
    content: [
      Text(
        'Editando pessoa',
        style: textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      TextFieldDesign(theme: theme, textTheme: textTheme, hintText: 'Novo nome', icon: Icons.account_circle_outlined, controller: nameController),
      ButtonDesign(theme: theme, textTheme: textTheme, childText: 'Salvar', onPressed: (){
        final navigator = Navigator.of(context);
        peopleState.editPessoa(index, nameController.text);
        nameController.clear();
        navigator.pop();
      }),
    ], 
    theme: theme
  );
}

void showEditPerson(BuildContext context, Event event, int index, PeopleState peopleState){
  final TextEditingController editingController = TextEditingController();
  editingController.text = event.people[index].nome;
  showModalBottomSheet(
    context: context, 
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context){
      return Padding(padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: EditPersonContainer(theme: Theme.of(context), textTheme: Theme.of(context).textTheme, context: context, nameController: editingController, event: event, index: index, peopleState: peopleState),
      );
    }
  );
}

Widget AddConsumedProductContainer({
  required ThemeData theme,
  required TextTheme textTheme,
  required BuildContext context,
  required PeopleState peopleState,
}){
  final navigator = Navigator.of(context);
  return SlideUpContainer(
    content: [
      Text(
        'Adicionar produto consumido',
        style: textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.4, // altura limitada
        child: ListView(
          children: [
            ...peopleState.event.compradores.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              return ListTile(
                title: Text(product.nome),
              );
            })
          ],
        ),
      ),
    ],
    theme: theme
  );
}