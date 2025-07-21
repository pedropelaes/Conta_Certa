import 'package:conta_certa/models/event.dart';
import 'package:conta_certa/screens/people_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:conta_certa/widgets/appbars.dart';

class EventManagerScreen extends StatefulWidget {
  final Event event;

  const EventManagerScreen({super.key, required this.event});

  @override
  State<EventManagerScreen> createState() => _EventManagerScreenState();
}

class _EventManagerScreenState extends State<EventManagerScreen> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      PeopleScreen(event: widget.event),
      const Center(child: Text('Produtos')),
      const Center(child: Text('Financeiro')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MediumAppBar(theme: theme, textTheme: textTheme, title: widget.event.title, onSearch: () {}, ),
          SliverToBoxAdapter(
            child: 
              Divider(
                thickness: 5,
                color: theme.colorScheme.secondary,
              ),
          ),
          SliverToBoxAdapter(
            child: _pages[_currentIndex],
          )
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.add, size: 30, color: theme.colorScheme.onPrimary,),
      ),
    );
  }
  
}
