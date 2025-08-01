import 'package:conta_certa/models/event.dart';
import 'package:conta_certa/screens/buyers_screen.dart';
import 'package:conta_certa/screens/people_screen.dart';
import 'package:conta_certa/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:conta_certa/widgets/appbars.dart';
import 'package:provider/provider.dart';
import 'package:conta_certa/state/events_state.dart';

class EventManagerScreen extends StatefulWidget {

  const EventManagerScreen({super.key});

  @override
  State<EventManagerScreen> createState() => _EventManagerScreenState();
}

class _EventManagerScreenState extends State<EventManagerScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productValueController = TextEditingController();
  final TextEditingController buyerNameController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    productNameController.dispose();
    productValueController.dispose();
    buyerNameController.dispose();
    super.dispose();
  }

  int _currentIndex = 0;
  late List<Widget> _pages;

  late Event event;
  late EventsState eventsState;
  @override
  void initState() {
    super.initState();
    eventsState = Provider.of<EventsState>(context, listen: false);
    event = eventsState.selectedEvent!;

    _pages = [
      PeopleScreen(),
      ProductsScreen(),
      BuyersScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    List<String> contents = ["Pessoas", "Produtos", "Compradores"];
    String title = '${event.title} - ${contents[_currentIndex]}';

    return ChangeNotifierProvider<EventsState>.value(
      value: eventsState,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            MediumAppBar(theme: theme, textTheme: textTheme, title: title, onSearch: () {}, hasSearch: false ),
            SliverToBoxAdapter(
              child: 
                Divider(
                  thickness: 5,
                  color: theme.colorScheme.secondary,
                ),
            ),
            _pages[_currentIndex]
          ],
        ),
        bottomNavigationBar: PlatformNavBar(
          currentIndex: _currentIndex,
          itemChanged: (index) => {setState(() => _currentIndex = index)},
          cupertino: (_, __) => CupertinoTabBarData(
            activeColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surface
          ),
          material3: (_, __) => MaterialNavigationBarData(
            backgroundColor: theme.colorScheme.surfaceContainer,
            selectedIndex: _currentIndex,
          ),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: "Pessoas"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "Produtos"),
            BottomNavigationBarItem(icon: Icon(Icons.attach_money_rounded), label: "Financeiro")
          ],
        ),
        floatingActionButton: getFloatingActionButton(_currentIndex, event)
      ),
    );
  }
  
  Widget? getFloatingActionButton(int index, Event event){
    switch (index){
      case 0:
        return FloatingActionButton(
        onPressed: (){
          showAddPerson(context, nameController, eventsState);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, size: 30, color: Theme.of(context).colorScheme.onPrimary,),
      );
      case 1:
        return FloatingActionButton(
        onPressed: (){
          showAddProduct(context, productNameController, productValueController, eventsState);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, size: 30, color: Theme.of(context).colorScheme.onPrimary,),
      );
      case 2:
        return FloatingActionButton(
        onPressed: (){
          showAddBuyer(context, nameController, eventsState);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, size: 30, color: Theme.of(context).colorScheme.onPrimary,),
      );
      default:
        return null;
    }
  }
}

void showAddPerson(BuildContext context, TextEditingController nameController, EventsState eventsState){
  
  showModalBottomSheet(
    context: context, 
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context){
      return Padding(padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: AddPersonContainer(theme: Theme.of(context), textTheme: TextTheme.of(context), context: context, nameController: nameController, eventsState: eventsState),
      );
    }
  ).then((_){
    nameController.clear();
  });
}

void showAddProduct(BuildContext context, TextEditingController nameController, TextEditingController productValueController,EventsState eventsState){
  showModalBottomSheet(
    context: context, 
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context){
      return Padding(padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: AddProductContainer(theme: Theme.of(context), textTheme: TextTheme.of(context), context: context, nameController: nameController, valueController: productValueController, eventsState: eventsState),
      );
    }
  ).then((_){
    nameController.clear();
    productValueController.clear();
  });
}

void showAddBuyer(BuildContext context, TextEditingController nameController, EventsState eventsState){
  showModalBottomSheet(
    context: context, 
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context){
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddBuyerContainer(theme: Theme.of(context), textTheme: Theme.of(context).textTheme, context: context, nameController: nameController, eventsState: eventsState),
      );
    }
  ).then((_){
    nameController.clear();
  });
}