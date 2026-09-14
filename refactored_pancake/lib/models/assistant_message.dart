enum MessageSender {
  user,
  assistant;

  static MessageSender fromJson(String value) {
    switch (value) {
      case 'user':
        return MessageSender.user;
      case 'assistant':
        return MessageSender.assistant;
      default:
        throw ArgumentError('Unknown MessageSender: $value');
    }
  }

  String toJson() => name;
}

class AssistantMessage {
  final String id;
  final MessageSender sender;
  final String text;
  final String date;
  final String time;

  AssistantMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.date,
    required this.time,
  });

  factory AssistantMessage.fromJson(Map<String, dynamic> json) {
    return AssistantMessage(
      id: json['id'] as String,
      sender: MessageSender.fromJson(json['sender'] as String),
      text: json['text'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender.toJson(),
      'text': text,
      'date': date,
      'time': time,
    };
  }
}
