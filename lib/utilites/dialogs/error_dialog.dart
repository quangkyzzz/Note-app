import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'An error has occur',
    content: text,
    optionBuilder: () {
      Map<String, String?> mMap = {'OK': null};
      return mMap;
    },
  );
}
