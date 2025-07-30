import 'package:conta_certa/screens/main_screen.dart';
import 'package:conta_certa/state/financial_state.dart';
import 'package:conta_certa/theme/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:device_preview/device_preview.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conta_certa/state/events_state.dart';

import 'screens/opening_screen.dart';

import 'theme/theme.dart';
import 'theme/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool("first_launch") ?? true;
  final savedTheme = prefs.getString('selected_theme') ?? 'system';

  // Inicializa com o tema salvo
  final themeNotifier = ThemeNotifier();

  switch (savedTheme) {
    case "light":
      themeNotifier.setTheme(ThemeMode.light);
      break;
    case "light_high_contrast":
      themeNotifier.setTheme(ThemeMode.light, highContrast: true);
      break;
    case "dark":
      themeNotifier.setTheme(ThemeMode.dark);
      break;
    case "dark_high_contrast":
      themeNotifier.setTheme(ThemeMode.dark, highContrast: true);
      break;
    default:
      themeNotifier.setTheme(ThemeMode.system);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>.value(value: themeNotifier),
        ChangeNotifierProvider<EventsState>(create: (_) => EventsState()),
        ChangeNotifierProvider<FinancialState>(create: (_) => FinancialState()),
      ],
      child: DevicePreview(
        enabled: false, //kIsWeb || (!Platform.isAndroid && !Platform.isIOS),
        builder: (context) => MainApp(isFirstLaunch: isFirstLaunch),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MainApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    final textTheme = createTextTheme(context, "Inter", "ABeeZee");
    final MaterialTheme lightScheme = MaterialTheme(textTheme);
    final MaterialTheme darkScheme = MaterialTheme(textTheme);
    final themeNotifier = Provider.of<ThemeNotifier>(context); 
    final isHighContrast = themeNotifier.isHighContrast;

    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      theme: isHighContrast ? lightScheme.lightHighContrast() : lightScheme.light(), 
      darkTheme: isHighContrast ? darkScheme.darkHighContrast() : darkScheme.dark(), 
      themeMode: themeNotifier.themeMode, 
      home: isFirstLaunch ? OpeningScreen() : MainScreen(),
    );
  }
}
