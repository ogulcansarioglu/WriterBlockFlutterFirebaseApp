
import 'package:flutter/material.dart';
import 'package:learningdart/utility/dialogs/generic_dialog.dart';

Future<void> showErrorDialog (
  BuildContext context,
  String text
) async {
  return showGenericDialog(
    context: context, 
    title: "Error Occurred", 
    content: text, 
    optionBuilder: () => {
      'OK' : null,
    }
    );
}