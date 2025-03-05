import 'dart:convert';

import 'package:http/http.dart' as http;

// دالة لإرسال البريد الإلكتروني عبر EmailJS
Future<void> sendEmail(String email, String subject, String message) async {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'service_id': 'service_l34ibgn',
      'template_id': 'template_clyw3or',
      'user_id': 't9cuPuWkit9--lEt-',
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
