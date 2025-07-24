import 'package:conta_certa/screens/buyers_screen.dart';
import 'package:conta_certa/state/financial_state.dart';
import 'package:conta_certa/widgets/cards.dart';
import 'package:conta_certa/widgets/list_widgets/person_list_option.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:conta_certa/state/events_state.dart';

class BuyerFinancesScreen extends StatefulWidget {
  final buyerIndex;

  const BuyerFinancesScreen({super.key, required this.buyerIndex});

  @override
  State<BuyerFinancesScreen> createState() => _BuyerFinancesScreenState();
}

class _BuyerFinancesScreenState extends State<BuyerFinancesScreen> {
  late FinancialState financialState;
  @override 
  void initState(){
    super.initState();
    financialState = Provider.of<FinancialState>(context, listen: false);
    financialState.loadSelectedPeople(widget.buyerIndex);
  }

  @override
  Widget build(BuildContext context) {
    final formatador = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final eventsState = Provider.of<EventsState>(context);
    financialState.getEvent(eventsState.selectedEvent!);
    financialState.getInDebtPeople(widget.buyerIndex);
    final buyer = eventsState.selectedEvent!.compradores[widget.buyerIndex];
    final totalValue = financialState.calculateTotalValue(widget.buyerIndex);
    return ChangeNotifierProvider<FinancialState>.value(
      value: financialState,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            buyer.nome,
            style: textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                    thickness: 5,
                    color: theme.colorScheme.secondary,
                  ),
              Consumer<FinancialState>(
                builder: (context, financialState, _){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueCard(theme: theme, textTheme: textTheme, title: 'Valor total:', value: formatador.format(totalValue), context: context),
                      ValueCard(theme: theme, textTheme: textTheme, title: 'A receber:', value: formatador.format(financialState.calculateToReceiveValue(totalValue, widget.buyerIndex)), context: context),
                    ],
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: FinancialListCard(
                  theme: theme, textTheme: textTheme, context: context,
                  list: Consumer<FinancialState>(
                    builder: (context, financialState, _){
                      if(financialState.inDebt.isEmpty){
                        return Text(
                          'Nenhuma pessoa deve a esse comprador.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold
                          ),
                        );
                      }else{
                      return ListView(
                          children: [
                            ...financialState.inDebt.asMap().entries.map((entry) {
                              final person = entry.value;
                              final personDebt = financialState.calculatePersonDebt(person, widget.buyerIndex) ;
                              var isChecked = financialState.selectedPeople[person.nome] ?? false;
                              return Column(
                                children: [
                                  buildPersonOption(theme: theme, textTheme: textTheme, context: context, 
                                  isChecked: isChecked,
                                  onChanged: (_) {
                                    financialState.toggleSelectedPerson(person, widget.buyerIndex);
                                  }, 
                                  nome: person.nome, 
                                  value: formatador.format(personDebt),
                                  ),
                                  listDivider(theme: theme),
                                ],
                              );
                            })
                          ],
                        );
                      }
                    },
                  )
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}