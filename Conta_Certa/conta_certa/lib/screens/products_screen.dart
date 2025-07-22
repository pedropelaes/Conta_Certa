import 'package:conta_certa/screens/main_screen.dart';
import 'package:conta_certa/screens/settings.dart';
import 'package:conta_certa/widgets/buttons.dart';
import 'package:conta_certa/widgets/cards.dart';
import 'package:conta_certa/widgets/dialogs.dart';
import 'package:conta_certa/widgets/slide_up_container.dart';
import 'package:conta_certa/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget{
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    
    return Consumer<EventsState>(
      builder: (context, eventsState, _){
        final event = eventsState.selectedEvent!;
        final products = event.produtos;

        if (products.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Text("Você ainda não adicionou nenhum produto, eles aparecerão aqui.", style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ), textAlign: TextAlign.center, ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index){
              final produto = products[index];
              return ProductCard(
                context: context, theme: theme, textTheme: textTheme, 
                onOpen: (){/*has to be empty*/}, 
                onDelete: (){
                  showPlatformDialog(
                    context: context,
                    builder: (_) => dialogDesign(
                      theme: theme, textTheme: textTheme, title: 'Deseja mesmo apagar ${produto.nome} ?', 
                      body: 'Não há reversão para essa ação. Todas as informações relacionadas a esse produto serão perdidas', 
                      confirm: 'Apagar', 
                      onConfirm: (){eventsState.deleteProduto(index);}, 
                      context: context
                    )
                  );
                }, 
                onEdit: (){},
                name: produto.nome, 
                value: produto.valor.toString()
              );
            },
            childCount: products.length,
          ) 
        );
      }
    );
  }
}

Widget AddProductContainer({
  required ThemeData theme,
  required TextTheme textTheme,
  required BuildContext context,
  required TextEditingController nameController,
  required TextEditingController valueController,
  required EventsState eventsState,
}){
  return SlideUpContainer(
    content: [
      Text(
        'Adicionando produto',
        style: textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      TextFieldDesign(theme: theme, textTheme: textTheme, hintText: "Nome do produto", icon: Icons.edit, controller: nameController),
      TextFieldDesign(theme: theme, textTheme: textTheme, hintText: "Valor gasto", icon: Icons.attach_money_rounded, controller: valueController, isNumber: true),
      ButtonDesign(theme: theme, textTheme: textTheme, childText: 'Criar', onPressed: (){
        final navigator = Navigator.of(context);
        eventsState.addProduto(nameController.text, double.parse(valueController.text.replaceAll(',', '.')));
        nameController.clear();
        valueController.clear();
        navigator.pop();
      })
    ], 
    theme: theme
  );
}