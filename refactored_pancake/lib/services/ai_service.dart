import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AiService {
  Future<String> getCompletion(String context) async {
    final endpoint = dotenv.env['AZURE_AI_ENDPOINT']!;
    final apiKey = dotenv.env['AZURE_AI_API_KEY']!;
    final model = dotenv.env['AZURE_AI_MODEL']!;

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'api-key': apiKey,
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'input': context,
        'messages': [
          {'role': 'user', 'content': context},
        ],
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['choices'] is List && (data['choices'] as List).isNotEmpty) {
        final message = data['choices'][0]['message'];
        if (message != null && message['content'] != null) {
          return message['content'].toString().trim();
        }
      }

      if (data['output_text'] != null) {
        return data['output_text'].toString().trim();
      }
      if (data['output'] is String) {
        return data['output'].toString().trim();
      }

      return response.body;
    } else {
      String errorMessage = 'Request failed with status ${response.statusCode}';
      try {
        final errorData = jsonDecode(response.body);
        if (errorData is Map &&
            errorData['error'] != null &&
            errorData['error']['message'] != null) {
          errorMessage = errorData['error']['message'];
        }
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }
}
