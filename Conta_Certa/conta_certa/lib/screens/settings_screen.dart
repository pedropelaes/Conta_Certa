import 'package:conta_certa/theme/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Settings extends StatefulWidget {
  const Settings ({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final Map<String, bool> _themeOptions = {
    "system": true,
    "light": false,
    "light_high_contrast": false,
    "dark": false,
    "dark_high_contrast": false,
  };

  void _onOptionChanged(String optionText, bool? newValue) async {
    if (newValue == false && _themeOptions[optionText] == true){
      int checkedCount = _themeOptions.values.where((value)=>value).length;
      if(checkedCount == 1) return;
    }
    
    setState(() {
      _themeOptions.forEach((key, value) {
        _themeOptions[key] = false;
      });
      _themeOptions[optionText] = newValue ?? false;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_theme', optionText);
  }

  @override
  void initState(){
    super.initState();
    _loadSavedTheme();
    _getAppVersion();
  }

  void _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('selected_theme') ?? 'system';

    setState((){
      _themeOptions.updateAll((key, value) => false);
      _themeOptions[savedTheme] = true;
    });

    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

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
  }

  String _version = '...';
  String _buildNumber = '...';

  Future<void> _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final TextStyle list = textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ) ?? const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold); // fallback

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: 
            Text(
              "Configurações",
              textAlign: TextAlign.left,
              style: textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          backgroundColor: theme.colorScheme.surface,
          brightness: theme.brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                  thickness: 5,
                  color: theme.colorScheme.secondary,
              ),
              Card(
                color: theme.colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tema do aplicativo:",
                        textAlign: TextAlign.left,
                        style: textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      _buildThemeOption(context: context, text: "Sistema", textStyle: list, isChecked: _themeOptions["system"]!, 
                      onChanged: (bool? value) => {_onOptionChanged("system", value), themeNotifier.setTheme(ThemeMode.system)}, theme: theme),
                      listDivider(theme: theme),
                      _buildThemeOption(context: context, text: "Claro", textStyle: list, isChecked: _themeOptions["light"]!, 
                      onChanged: (bool? value)=> {_onOptionChanged("light", value), themeNotifier.setTheme(ThemeMode.light)}, theme: theme),
                      listDivider(theme: theme),
                      _buildThemeOption(context: context, text: "Claro com contraste alto", textStyle: list, isChecked: _themeOptions["light_high_contrast"]!, 
                      onChanged: (bool? value)=> {_onOptionChanged("light_high_contrast", value), themeNotifier.setTheme(ThemeMode.light, highContrast: true)}, theme: theme),
                      listDivider(theme: theme),
                      _buildThemeOption(context: context, text: "Escuro", textStyle: list, isChecked: _themeOptions["dark"]!, 
                      onChanged: (bool? value)=> {_onOptionChanged("dark", value), themeNotifier.setTheme(ThemeMode.dark)}, theme: theme),
                      listDivider(theme: theme),
                      _buildThemeOption(context: context, text: "Escuro com contraste alto", textStyle: list, isChecked: _themeOptions["dark_high_contrast"]!, 
                      onChanged: (bool? value)=> {_onOptionChanged("dark_high_contrast", value), themeNotifier.setTheme(ThemeMode.dark, highContrast: true)}, theme: theme),
                      listDivider(theme: theme),
                    ],
                  ),
                ),
              ),
              Card(
                color: theme.colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        "Reporte um bug:",
                        style: textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        'Caso tenha algum problema utilizando nosso app, nos envie um e-mail, ou publique uma issue no nosso repositório!',
                        style: textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                        ),
                      ),
                      SizedBox(height: 4),
                      InkWell(
                        onTap: () async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: "contacerta025@gmail.com",
                            query: Uri.encodeFull('subject=Reporte de bug&body=Olá, encontrei um problema no app...')
                          );
                          if (await canLaunchUrl(emailLaunchUri)) {
                            await launchUrl(emailLaunchUri);
                          }
                        },
                        child: Text(
                          'contacerta025@gmail.com',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: theme.colorScheme.onPrimaryContainer
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      InkWell(
                        onTap: () async {
                          final Uri url = Uri.parse('https://github.com/pedropelaes/Conta_Certa/issues');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Text(
                          'github.com/pedropelaes/Conta_Certa',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: theme.colorScheme.onPrimaryContainer
                          ),
                        ),
                      )
                    ]
                  ),
                ),
              ),
              Card(
                color: theme.colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        "Sobre o app:",
                        style: textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        'Conta Certa é um aplicativo desenvolvido para simplificar a divisão de despesas em confraternizações, como churrascos, festas e encontros entre amigos. Trata-se de um projeto pessoal, criado com foco em aprimoramento técnico e aprendizado em desenvolvimento de software.',
                        style: textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                        ),
                      ),
                    ]
                  ),
                ),
              ),
              Card(
                color: theme.colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    children: [
                      Text("Versão do app: ",
                        style: textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        'V$_version | Build:$_buildNumber',
                        style: textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                        ),
                      )
                    ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget listDivider({
  required ThemeData theme
}){
  return Divider(height: 5, thickness: 2, color: theme.colorScheme.onPrimaryContainer,);
}

bool isIOSPlatform(BuildContext context) {
  return Theme.of(context).platform == TargetPlatform.iOS;
}

Widget _buildThemeOption({
  required BuildContext context,
  required ThemeData theme,
  required String text,
  required TextStyle textStyle,
  required bool isChecked,
  required ValueChanged<bool?> onChanged,
}) {
  if (isIOSPlatform(context)){
    return InkWell(
      onTap: (){onChanged(true);},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: textStyle,),
            if(isChecked) Icon(Icons.check_rounded, color: theme.colorScheme.onPrimaryContainer),
          ],
        ),
      ),
    );
  }else{
    return ListTile(
      title: Text(
        text,
        style: textStyle,
      ),
      trailing: PlatformCheckbox(
        value: isChecked,
        onChanged: onChanged,
      ),
      onTap: (){onChanged(true);}
    );
  }
}

