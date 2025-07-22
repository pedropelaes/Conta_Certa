
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget TextFieldDesign({
  required ThemeData theme,
  required TextTheme textTheme,
  required String hintText,
  required IconData icon,
  required TextEditingController controller,
  bool isNumber = false,
  String decimalSeparator = ','
}){
return TextField(
  keyboardType: isNumber ? TextInputType.number : TextInputType.text,
  inputFormatters: isNumber
        ? [DecimalTextInputFormatter(decimalSeparator: decimalSeparator)] 
        : null,
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: theme.colorScheme.onSecondaryContainer,),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: theme.colorScheme.onSecondaryContainer, strokeAlign: 3)
      ),
    ),
    style: textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.onSecondaryContainer
    ),
    controller: controller,
  );
}


class DecimalTextInputFormatter extends TextInputFormatter {
  final String decimalSeparator;

  DecimalTextInputFormatter({this.decimalSeparator = '.'});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (newText.isEmpty) {
      return newValue;
    }

    final regExp = RegExp(r'^\d*[' + RegExp.escape(decimalSeparator) + r']?\d*$');

    if (!regExp.hasMatch(newText)) {
      return oldValue; 
    }

    if (newText.indexOf(decimalSeparator) != newText.lastIndexOf(decimalSeparator)) {
      return oldValue; 
    }

    return newValue;
  }
}