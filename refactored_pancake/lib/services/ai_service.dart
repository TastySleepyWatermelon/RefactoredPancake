import 'package:ai_sdk_azure/ai_sdk_azure.dart';
import 'package:ai_sdk_dart/ai_sdk_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService {
  Future<String> getCompletion(String context) async {
    final rawEndpoint = dotenv.env['AZURE_AI_ENDPOINT'] ?? '';
    final apiKey = dotenv.env['AZURE_AI_API_KEY'] ?? '';
    final model = dotenv.env['AZURE_AI_MODEL'] ?? '';

    if (rawEndpoint.isEmpty || apiKey.isEmpty || model.isEmpty) {
      throw Exception('Invalid environment variables.');
    }

    final uri = Uri.tryParse(rawEndpoint);
    final endpoint = (uri != null && uri.hasScheme && uri.hasAuthority)
        ? '${uri.scheme}://${uri.authority}'
        : rawEndpoint;

    final provider = AzureOpenAIProvider(
      endpoint: endpoint,
      apiKey: apiKey,
    );

    final result = await generateText(
      model: provider(model),
      prompt: context,
    );

    return result.text;
  }
}
