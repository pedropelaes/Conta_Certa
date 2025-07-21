import 'package:conta_certa/models/event.dart';
import 'package:conta_certa/models/people.dart';
import 'package:conta_certa/widgets/buttons.dart';
import 'package:conta_certa/widgets/cards.dart';
import 'package:conta_certa/widgets/slide_up_container.dart';
import 'package:conta_certa/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PeopleState extends ChangeNotifier{
  final List<Pessoa> _pessoas = [];
  
  List<Pessoa> get pessoas => List.unmodifiable(_pessoas);

  void addPessoa (String nome, Event event){
    _pessoas.add(Pessoa(nome: nome));
    event.people.add(Pessoa(nome: nome));
    notifyListeners();
  }

  void deletePessoa (int index, Event event){
    _pessoas.remove(index);
    event.people.remove(index);
    notifyListeners();
    Fluttertoast.showToast(
      msg: "Pessoa deletada.",
    );
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
    final peopleState = Provider.of<PeopleState>(context, listen: false);
    final TextEditingController editingController = TextEditingController();
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Column(
      children: [
        PersonCard(theme: theme, textTheme: textTheme, name: "Você", onDelete: (){}, onEdit: (){showEditPerson(context, editingController, widget.event);}, onAdd: (){}),
      ]
    );
  }
}
Widget AddPersonContainer({
  required ThemeData theme,
  required TextTheme textTheme,
  required BuildContext context,
  required TextEditingController nameController,
  required Event event,
  
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
        final peopleState = Provider.of<PeopleState>(context, listen: false);
        peopleState.addPessoa(nameController.text, event);
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
        final peopleState = Provider.of<PeopleState>(context, listen: false);
        peopleState.addPessoa(nameController.text, event);
        nameController.clear();
        navigator.pop();
      }),
    ], 
    theme: theme
  );
}

void showEditPerson(BuildContext context, TextEditingController nameController, Event event){
  showModalBottomSheet(
    context: context, 
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context){
      return Padding(padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: EditPersonContainer(theme: Theme.of(context), textTheme: TextTheme.of(context), context: context, nameController: nameController, event: event),
      );
    }
  );
}