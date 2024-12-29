import 'package:flutter/material.dart';

class PagesHelpers {
  static void loadPage(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  static void loadPageReplace(BuildContext context, Widget route) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => route),
        (Route<dynamic> route) => false);
  }
}
