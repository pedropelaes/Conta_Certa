import 'package:conta_certa/models/event.dart';
import 'package:conta_certa/models/people.dart';
import 'package:conta_certa/screens/buyer_finances_screen.dart';
import 'package:conta_certa/widgets/buttons.dart';
import 'package:conta_certa/widgets/cards.dart';
import 'package:conta_certa/widgets/dialogs.dart';
import 'package:conta_certa/widgets/list_widgets/product_list_option.dart';
import 'package:conta_certa/widgets/slide_up_container.dart';
import 'package:conta_certa/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:conta_certa/state/events_state.dart';

class BuyersScreen extends StatelessWidget{
  const BuyersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Consumer<EventsState>(
      builder: (context, eventsState, _) {
        final event = eventsState.selectedEvent!;
        final compradores = event.compradores;
        if(compradores.isEmpty){
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Text("Você ainda não adicionou nenhum comprador, eles aparecerão aqui.", style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold
                  ), textAlign: TextAlign.center,),
                ),
            )
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index){
              final comprador = compradores[index];
              return PersonCard(
                isBuyer: true,
                theme: theme, textTheme: textTheme, 
                name: comprador.nome, 
                onDelete: (){
                  showPlatformDialog(
                    context: context,
                    builder: (_) => dialogDesign(
                      theme: theme, textTheme: textTheme, title: 'Deseja mesmo apagar ${comprador.nome} ?', 
                      body: 'Não há reversão para essa ação. Todas as informações relacionadas a esse comprador serão perdidas', 
                      confirm: 'Apagar', 
                      onConfirm: (){eventsState.deleteComprador(index);}, 
                      context: context
                    )
                  );
                }, 
                onEdit: (){
                  showEditBuyer(context, event, index, eventsState);
                }, 
                onAdd: (){
                  if(eventsState.selectedEvent!.produtos.isEmpty){
                    showPlatformDialog(
                      context: context,
                      builder: (_) => dialogDesign(
                        theme: theme,
                        textTheme: textTheme,
                        title: 'Não há produtos criados',
                        body: 'Para relacionar um produto com um comprador, é preciso antes ter criado produtos.',
                        confirm: 'Confirmar',
                        onConfirm: () {},
                        context: context,
                      )
                    );
                  }else{
                    showModalBottomSheet(
                      context: context, 
                      builder: (_) => AddBoughtProductContainer(theme: theme, textTheme: textTheme, context: context, eventsState: eventsState, buyer: comprador, indexComprador: index)
                    );
                  }
                },
                onOpen: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (_) => BuyerFinancesScreen(buyerIndex: index,) 
                    )
                  );
                }, 
                context: context
              );
            },
            childCount: compradores.length,
          ),
        );
      }
    );
  }
}

Widget AddBuyerContainer({
  required ThemeData theme,
  required TextTheme textTheme,
  required BuildContext context,
  required TextEditingController nameController,
  required EventsState eventsState
}){
  return SlideUpContainer(
    content: [
      Text(
        'Adicionando comprador',
        style: textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      TextFieldDesign(theme: theme, textTheme: textTheme, hintText: 'Nome do comprador', icon: Icons.account_circle_outlined, controller: nameController),
      ButtonDesign(theme: theme, textTheme: textTheme, childText: 'Adicionar', onPressed: (){
        if(nameController.text == ""){
          Fluttertoast.showToast(msg: "Por favor, preencha o campo do nome do comprador.");
        }
        else{
          final navigator = Navigator.of(context);
          eventsState.addComprador(nameController.text);
          nameController.clear();
          navigator.pop();
        }
      }),
    ], 
    theme: theme
  );
}

Widget EditBuyerContainer({
  required ThemeData theme,
  required TextTheme textTheme,
  required BuildContext context,
  required TextEditingController nameController,
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
        eventsState.editComprador(index, nameController.text);
        nameController.clear();
        navigator.pop();
      }),
    ], 
    theme: theme
  );
}

void showEditBuyer(BuildContext context, Event event, int index, EventsState eventsState){
  final TextEditingController editingController = TextEditingController();
  editingController.text = event.compradores[index].nome;
  showModalBottomSheet(
    context: context, 
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context){
      return Padding(padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: EditBuyerContainer(theme: Theme.of(context), textTheme: Theme.of(context).textTheme, context: context, 
      nameController: editingController, index: index, eventsState: eventsState, oldName: event.compradores[index].nome),
      );
    }
  );
}

Widget AddBoughtProductContainer({
  required ThemeData theme,
  required TextTheme textTheme,
  required BuildContext context,
  required EventsState eventsState,
  required Comprador buyer,
  required int indexComprador,
}){
  return SlideUpContainer(
    content: [
      Text(
        'Adicionar produto comprado por ${buyer.nome}',
        style: textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Consumer<EventsState>(
          builder: (context, eventsState, _) {
            final buyer = eventsState.selectedEvent!.compradores[indexComprador];

            return ListView(
              children: [
                ...eventsState.selectedEvent!.produtos.asMap().entries.map((entry) {
                  final product = entry.value;
                  final isChecked = buyer.comprados.contains(product);

                  return Column(
                    children: [
                      buildProductOption(
                        theme: theme,
                        textTheme: textTheme,
                        context: context,
                        isChecked: isChecked,
                        onChanged: (_) {
                          eventsState.toggleProdutoComprado(product, indexComprador);
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