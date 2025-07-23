import 'package:conta_certa/models/event.dart';
import 'package:conta_certa/models/people.dart';
import 'package:conta_certa/screens/main_screen.dart';
import 'package:conta_certa/widgets/buttons.dart';
import 'package:conta_certa/widgets/cards.dart';
import 'package:conta_certa/widgets/dialogs.dart';
import 'package:conta_certa/widgets/product_list_option.dart';
import 'package:conta_certa/widgets/slide_up_container.dart';
import 'package:conta_certa/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeopleScreen extends StatefulWidget {  
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Consumer<EventsState>(
      builder: (context, eventsState, _) {
        final event = eventsState.selectedEvent!;
        final pessoas = event.people;
        // Proper sliver implementation
        if (pessoas.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Text("Você ainda não adicionou nenhuma pessoa, elas aparecerão aqui.", style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold
                ), textAlign: TextAlign.center,),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final person = pessoas[index];
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
                        onConfirm: (){eventsState.deletePessoa(index);}, 
                        context: context
                      )
                    );
                },
                onEdit: () => showEditPerson(context, event, index, eventsState),
                onAdd: () {
                  if(eventsState.selectedEvent!.produtos.isEmpty){
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
                      builder: (_) => AddConsumedProductContainer(theme: theme, textTheme: textTheme, context: context, eventsState: eventsState, person: person ,indexPessoa: index)
                    );
                  }
                },
                context: context
              );
            },
            childCount: pessoas.length,
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
  required EventsState eventsState
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
        if(nameController.text == ""){
          Fluttertoast.showToast(msg: "Por favor, preencha o campo do nome da pessoa.");
        }
        else{
          final navigator = Navigator.of(context);
          eventsState.addPessoa(nameController.text);
          nameController.clear();
          navigator.pop();
        }
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
  required EventsState eventsState,
  required String oldName,
}){
  return SlideUpContainer(
    content: [
      Text(
        'Editando $oldName',
        style: textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      TextFieldDesign(theme: theme, textTheme: textTheme, hintText: 'Novo nome', icon: Icons.account_circle_outlined, controller: nameController),
      ButtonDesign(theme: theme, textTheme: textTheme, childText: 'Salvar', onPressed: (){
        final navigator = Navigator.of(context);
        eventsState.editPessoa(index, nameController.text);
        nameController.clear();
        navigator.pop();
      }),
    ], 
    theme: theme
  );
}

void showEditPerson(BuildContext context, Event event, int index, EventsState eventsState){
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
      child: EditPersonContainer(theme: Theme.of(context), textTheme: Theme.of(context).textTheme, context: context, nameController: editingController, event: event, 
      index: index, eventsState: eventsState, oldName: event.people[index].nome),
      );
    }
  );
}

Widget AddConsumedProductContainer({
  required ThemeData theme,
  required TextTheme textTheme,
  required BuildContext context,
  required EventsState eventsState,
  required Pessoa person,
  required int indexPessoa,
}){
  return SlideUpContainer(
    content: [
      Text(
        'Adicionar produto consumido por ${person.nome}',
        style: textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Consumer<EventsState>(
          builder: (context, eventsState, _) {
            final pessoa = eventsState.selectedEvent!.people[indexPessoa];

            return ListView(
              children: [
                ...eventsState.selectedEvent!.produtos.asMap().entries.map((entry) {
                  final product = entry.value;
                  final isChecked = pessoa.consumidos.contains(product);

                  return Column(
                    children: [
                      buildProductOption(
                        theme: theme,
                        textTheme: textTheme,
                        context: context,
                        isChecked: isChecked,
                        onChanged: (_) {
                          eventsState.toggleProdutoConsumido(product, indexPessoa);
                        },
                        nome: product.nome,
                      ),
                      listDivider(theme: theme),
                    ],
                  );
                }),
              ],
            );
          },
        ),
      )
    ],
    theme: theme
  );
}

Widget listDivider({
  required ThemeData theme
}){
  return Divider(height: 5, thickness: 2, color: theme.colorScheme.onSecondaryContainer,);
}