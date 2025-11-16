import 'package:biblio/core/constants/colors_constants.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, {int duration = 4}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: duration),
      backgroundColor: kDisableButtonColor,
      content: Text(
        text,
        style: const TextStyle(color: kMainColor),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
