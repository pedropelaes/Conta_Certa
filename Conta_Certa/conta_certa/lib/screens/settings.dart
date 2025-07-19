import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/cupertino.dart';

class Settings extends StatefulWidget {
  const Settings ({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, bool> _themeOptions = {
    "Sistema": true, // Inicialmente marcado
    "Claro": false,
    "Claro1": false,
    "Claro2": false,
    "Escuro": false,
    "Escuro1": false,
    "Escuro2": false,
  };

  void _onOptionChanged(String optionText, bool? newValue) {
    // 3. Usar setState para atualizar o estado e redesenhar a UI
    setState(() {
      // Desmarcar todas as outras opções (se for um radio button-like behavior)
      _themeOptions.forEach((key, value) {
        _themeOptions[key] = false;
      });
      // Marcar apenas a opção selecionada
      _themeOptions[optionText] = newValue ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final TextStyle list = textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ) ?? const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold); // fallback

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Row(
          children: [
            PlatformIconButton(
              onPressed: (){},
              icon: Icon(Icons.arrow_back),
              color: theme.colorScheme.onSurface,
            ),
            Text(
              "Configurações",
              style: textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Divider(
              thickness: 5,
              color: theme.colorScheme.secondary,
          ),
          Card(
            color: theme.colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: EdgeInsets.all(16),
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
                  _buildThemeOption(context: context, text: "Sistema", textStyle: list, isChecked: _themeOptions["Sistema"]!, onChanged: (bool? value) => {_onOptionChanged("Sistema", value)}, theme: theme),
                  listDivider(theme: theme),
                  _buildThemeOption(context: context, text: "Claro", textStyle: list, isChecked: _themeOptions["Claro"]!, onChanged: (bool? value)=> {_onOptionChanged("Claro", value)}, theme: theme),
                  listDivider(theme: theme),
                  _buildThemeOption(context: context, text: "Claro com contraste médio", textStyle: list, isChecked: _themeOptions["Claro1"]!, onChanged: (bool? value)=> {_onOptionChanged("Claro1", value)}, theme: theme),
                  listDivider(theme: theme),
                  _buildThemeOption(context: context, text: "Claro com contraste alto", textStyle: list, isChecked: _themeOptions["Claro2"]!, onChanged: (bool? value)=> {_onOptionChanged("Claro2", value)}, theme: theme),
                  listDivider(theme: theme),
                  _buildThemeOption(context: context, text: "Escuro", textStyle: list, isChecked: _themeOptions["Escuro"]!, onChanged: (bool? value)=> {_onOptionChanged("Escuro", value)}, theme: theme),
                  listDivider(theme: theme),
                  _buildThemeOption(context: context, text: "Escuro com contraste médio", textStyle: list, isChecked: _themeOptions["Escuro1"]!, onChanged: (bool? value)=> {_onOptionChanged("Escuro1", value)}, theme: theme),
                  listDivider(theme: theme),
                  _buildThemeOption(context: context, text: "Escuro com contraste alto", textStyle: list, isChecked: _themeOptions["Escuro2"]!, onChanged: (bool? value)=> {_onOptionChanged("Escuro2", value)}, theme: theme),
                  listDivider(theme: theme),
                ],
              ),
            ),
          )
        ],
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
      onTap: (){onChanged(!isChecked);}
    );
  }
}

