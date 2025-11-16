import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// دالة لإرسال البريد الإلكتروني عبر EmailJS
Future<void> sendEmail(String email, String subject, String message) async {
  final url = Uri.parse(dotenv.env['EMAIL_API'] ?? '');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'service_id': dotenv.env['EMAIL_SERVICE_ID'] ?? '',
      'template_id': dotenv.env['EMAIL_TEMPLATE_ID'] ?? '',
      'user_id': dotenv.env['EMAIL_PUBLIC_KEY_USERID'] ?? '',
      'template_params': {
        'to_email': email,
        'subject': subject,
        'message': message,
      },
    }),
  );

  if (response.statusCode == 200) {
  } else {}
}
