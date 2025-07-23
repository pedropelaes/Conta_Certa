import 'package:conta_certa/screens/main_screen.dart';
import 'package:conta_certa/widgets/appbars.dart';
import 'package:conta_certa/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

class BuyerFinancesScreen extends StatelessWidget {
  final buyerIndex;

  const BuyerFinancesScreen({super.key, required this.buyerIndex});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final eventsState = Provider.of<EventsState>(context);
    final buyer = eventsState.selectedEvent!.compradores[buyerIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          buyer.nome,
          style: textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: Column(
        children: [
          Divider(
                thickness: 5,
                color: theme.colorScheme.secondary,
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueCard(theme: theme, textTheme: textTheme, title: 'Valor total:', value: 'R\$99,99', context: context),
              ValueCard(theme: theme, textTheme: textTheme, title: 'A receber:', value: 'R\$99,99', context: context),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: FinancialListCard(theme: theme, textTheme: textTheme, context: context),
          )
        ],
      )
    );
  }
}