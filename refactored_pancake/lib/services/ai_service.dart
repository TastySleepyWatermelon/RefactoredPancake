import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Talks to the Azure AI Foundry Responses API (`/openai/v1/responses`).
///
/// Credentials are read from the `.env` file via `flutter_dotenv` rather
/// than being hard-coded here.
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

  String get _model => dotenv.env['AZURE_AI_MODEL'] ?? 'gpt-4o-mini';

  /// Sends [message] to the model, grounded by [systemPrompt] and preceded
  /// by [history] (each entry a `{'role': 'user'|'assistant', 'content': ...}`
  /// map), and returns the assistant's reply text.
  Future<String> sendMessage({
    required String systemPrompt,
    required List<Map<String, String>> history,
    required String message,
  }) async {
    final input = [
      {'role': 'system', 'content': systemPrompt},
      ...history,
      {'role': 'user', 'content': message},
    ];

    final response = await _client.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'api-key': _apiKey,
      },
      body: jsonEncode({
        'model': _model,
        'input': input,
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

  /// Single-shot convenience call: sends [context] as one user turn with no
  /// prior history, for callers that build their own combined prompt string.
  Future<String> getCompletion(String context) {
    return sendMessage(
      systemPrompt: 'You are Sanad, a helpful family-care coordination '
          'assistant. Answer briefly and warmly.',
      history: const [],
      message: context,
    );
  }

  /// Walks the Responses API `output` array to find the assistant's text.
  ///
  /// The array can contain other item types (e.g. tool calls); the reply
  /// lives in the item where `type == "message"`, inside its `content`
  /// array, in the part where `type == "output_text"`.
  String _extractOutputText(Map<String, dynamic> json) {
    final output = json['output'];
    if (output is List) {
      for (final item in output) {
        if (item is Map<String, dynamic> && item['type'] == 'message') {
          final content = item['content'];
          if (content is List) {
            for (final part in content) {
              if (part is Map<String, dynamic> &&
                  part['type'] == 'output_text' &&
                  part['text'] is String) {
                return part['text'] as String;
              }
            }
          }
        }
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
