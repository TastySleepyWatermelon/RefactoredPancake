import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Talks to the Azure AI Foundry "Responses" endpoint.
///
/// Credentials are read from the `.env` file (see `.env.example`) via
/// `flutter_dotenv` rather than being hard-coded here.
class AiService {
  AiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  String get _endpoint {
    final value = dotenv.env['AZURE_AI_ENDPOINT'];
    if (value == null || value.isEmpty) {
      throw StateError('AZURE_AI_ENDPOINT is not set in .env');
    }
    return value;
  }

  String get _apiKey {
    final value = dotenv.env['AZURE_AI_API_KEY'];
    if (value == null || value.isEmpty) {
      throw StateError('AZURE_AI_API_KEY is not set in .env');
    }
    return value;
  }

  String get _defaultModel => dotenv.env['AZURE_AI_MODEL'] ?? 'gpt-4o-mini';

  /// Sends [prompt] to the model and returns the generated text.
  ///
  /// Pass [model] to override the deployment configured via
  /// `AZURE_AI_MODEL` in `.env`.
  Future<String> generateText(String prompt, {String? model}) async {
    final response = await _client.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'api-key': _apiKey,
      },
      body: jsonEncode({
        'model': model ?? _defaultModel,
        'input': prompt,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'AI request failed (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return _extractOutputText(decoded);
  }

  String _extractOutputText(Map<String, dynamic> json) {
    // Convenience field some Responses API implementations include.
    final direct = json['output_text'];
    if (direct is String && direct.isNotEmpty) {
      return direct;
    }

    final output = json['output'];
    if (output is List) {
      final buffer = StringBuffer();
      for (final item in output) {
        if (item is Map<String, dynamic> && item['content'] is List) {
          for (final content in item['content'] as List) {
            if (content is Map<String, dynamic>) {
              final text = content['text'];
              if (text is String) {
                buffer.write(text);
              }
            }
          }
        }
      }
      if (buffer.isNotEmpty) {
        return buffer.toString();
      }
    }

    throw const FormatException('Unexpected AI response shape');
  }

  void dispose() => _client.close();
}

class HttpException implements Exception {
  HttpException(this.message);
  final String message;

  @override
  String toString() => message;
}
