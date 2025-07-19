import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:device_preview/device_preview.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'screens/openingScreen.dart';
import 'theme/theme.dart';
import 'theme/util.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: kIsWeb || !Platform.isAndroid && !Platform.isIOS,
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = createTextTheme(context, "Inter", "ABeeZee");
    final MaterialTheme lightScheme = MaterialTheme(textTheme);
    final MaterialTheme darkScheme = MaterialTheme(textTheme);

    return PlatformApp(
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      material: (_, __) => MaterialAppData(
        theme: lightScheme.light(), // Aplica o tema claro
        darkTheme: darkScheme.dark(), // Aplica o tema escuro
        themeMode: ThemeMode.system, // Usa o tema do sistema (claro/escuro)
      ),
      home: OpeningScreen(),
    );
  }
}
