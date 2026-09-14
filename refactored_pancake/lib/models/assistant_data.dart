import 'assistant_message.dart';

class AssistantData {
  final String dailySummary;
  final List<String> quickActionPrompts;
  final List<AssistantMessage> chatHistory;

  AssistantData({
    required this.dailySummary,
    required this.quickActionPrompts,
    required this.chatHistory,
  });

  factory AssistantData.fromJson(Map<String, dynamic> json) {
    return AssistantData(
      dailySummary: json['daily_summary'] as String,
      quickActionPrompts: (json['quick_action_prompts'] as List)
          .map((e) => e as String)
          .toList(),
      chatHistory: (json['chat_history'] as List)
          .map((e) => AssistantMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily_summary': dailySummary,
      'quick_action_prompts': quickActionPrompts,
      'chat_history': chatHistory.map((e) => e.toJson()).toList(),
    };
  }
}
