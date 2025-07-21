import 'package:conta_certa/models/event.dart';
import 'package:conta_certa/models/people.dart';
import 'package:conta_certa/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PeopleState extends ChangeNotifier{
  final List<Pessoa> _pessoas = [];
  List<Pessoa> get pessoas => List.unmodifiable(_pessoas);

  Future<void> savePessoa() async{
    
  }

  void addPessoa (String nome, Event event){
    _pessoas.add(Pessoa(nome: nome));
    notifyListeners();
  }

  void deletePessoa (int index){
    _pessoas.remove(index);
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
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Column(
      children: [
        PersonCard(theme: theme, textTheme: textTheme, name: "Você", onDelete: (){}, onEdit: (){}, onAdd: (){}),
      ]
    );
  }
}