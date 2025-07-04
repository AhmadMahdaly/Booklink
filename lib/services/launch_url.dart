import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    log('Could not launch $url');
  }
}
