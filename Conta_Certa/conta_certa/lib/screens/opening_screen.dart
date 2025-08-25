import 'package:conta_certa/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpeningScreen extends StatelessWidget {
  const OpeningScreen({super.key});
  
  Future<void> _openMainScreen(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    
    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseFontSize = 18.0; 
    final double tabletFontSize = screenWidth * 0.025; 
    final double responsiveFontSize = baseFontSize > tabletFontSize ? baseFontSize : tabletFontSize;
    final double dividerHeight = MediaQuery.of(context).size.height * 0.05;
    final double dividerThickness = MediaQuery.of(context).size.height * 0.003;

    return PlatformScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox( // makes the content fit in the screen size
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height, // min height is the screen size
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(flex: 2,),
                  LogoWithText(screenWidth: screenWidth),
                  Divider(
                    height: dividerHeight,
                    thickness: dividerThickness,
                    indent: 50,
                    endIndent: 50,
                    color: theme.colorScheme.primary,
                  ),
                  IntroductionText(responsiveFontSize: responsiveFontSize,),
                  Spacer(flex: 2,),
                  PlatformElevatedButton(
                    onPressed: () {
                      _openMainScreen(context);
                    },
                    color: theme.colorScheme.primaryContainer,
                    child: Text("Começar", style: textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: responsiveFontSize,
                    ),),
                  ),
                  Spacer(flex: 1,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LogoWithText extends StatelessWidget{
  final double screenWidth;
  const LogoWithText({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final double baseFontSize = 40.0; 
    final double tabletFontSize = screenWidth * 0.1; 
    final double responsiveFontSize = baseFontSize > tabletFontSize ? baseFontSize : tabletFontSize;

    final double baseImageWidth = 94.0;
    final double baseImageHeight = 104.0;
    final double responsiveImageWidth = screenWidth * 0.25; 
    final double responsiveImageHeight = responsiveImageWidth * (baseImageHeight / baseImageWidth);

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Image.asset(
          'assets/images/conta_certa_logo.png',
          width: responsiveImageWidth,
          height: responsiveImageHeight,
        ),
        Text(
          "Conta\nCerta", 
          style: textTheme.headlineLarge?.copyWith(
            color: Color(0xFF339966),
            fontSize: responsiveFontSize
          ),
        )
      ],
    );
  }
}

class IntroductionText extends StatelessWidget{
  final double responsiveFontSize;
  const IntroductionText({super.key, required this.responsiveFontSize});
  
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle paragraph = textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: responsiveFontSize,
              ) ?? const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold); // fallback

    final double verticalSpacing = MediaQuery.of(context).size.height * 0.04;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cansado daquela dor de cabeça na hora de dividir os gastos da confraternização?',
              textAlign: TextAlign.center,
              style: paragraph,
            ),
            SizedBox(height: verticalSpacing,),
            Text(
              'Com o Conta Certa, rachar a conta do churrasco, do bar ou de qualquer evento fica fácil e rápido!',
              textAlign: TextAlign.center,
              style: paragraph,
            ),
            SizedBox(height: verticalSpacing,),
            Text(
              'Chega de cálculos complicados e desentendimentos. Em poucos toques, você divide os valores de forma justa e transparente, para que todo mundo aproveite ao máximo sem preocupações. Role para baixo, e começe já!',
              textAlign: TextAlign.center,
              style: paragraph,
            )
        ])
      );
  }
}