import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class OpeningScreen extends StatelessWidget {
  const OpeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    final TextTheme textTheme = currentTheme.textTheme;

    return PlatformScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWithText()
          ],
        ),
      ),
    );
    
  }
}

class LogoWithText extends StatelessWidget{
  const LogoWithText({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    final TextTheme textTheme = currentTheme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/conta_certa_logo.png',
          width: 94,
          height: 104,
        ),
        Text(
          "Conta\nCerta", 
          style: textTheme.headlineLarge?.copyWith(
            color: Color(0xFF339966),
          ),
        )
      ],
    );
  }
}