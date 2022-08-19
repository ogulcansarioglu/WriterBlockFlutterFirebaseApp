
import 'package:flutter/cupertino.dart';
import 'package:learningdart/utility/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context, 
    title: "Log out", 
    content: "Are you sure you want to log out?", 
    optionBuilder: () => {
      'Cancel': false,
      'Log Out': true,
      },
  ).then((value) => value ?? null);
}