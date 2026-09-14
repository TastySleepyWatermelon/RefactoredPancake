enum TaskStatus {
  pending,
  done;

  static TaskStatus fromJson(String value) {
    switch (value) {
      case 'pending':
        return TaskStatus.pending;
      case 'done':
        return TaskStatus.done;
      default:
        throw ArgumentError('Unknown TaskStatus: $value');
    }
  }

  String toJson() => name;
}

class Task {
  final String? id;
  final String title;
  final String assignedTo;
  final String dueDate;
  final String dueTime;
  final TaskStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Task({
    this.id,
    required this.title,
    required this.assignedTo,
    required this.dueDate,
    required this.dueTime,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String?,
      title: json['title'] as String,
      assignedTo: json['assigned_to'] as String,
      dueDate: json['due_date'] as String,
      dueTime: json['due_time'] as String,
      status: TaskStatus.fromJson(json['status'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'assigned_to': assignedTo,
      'due_date': dueDate,
      'due_time': dueTime,
      'status': status.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
