class ConsoleLog {
  final int?     id;
  final DateTime dateTime;
  final String   content;
  final bool     isError;
  final bool     fromRobot;
  
  ConsoleLog({
    this.id,
    required this.dateTime,
    required this.content,
    required this.isError,
    required this.fromRobot,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'dateTime': dateTime.toIso8601String(),
      'content': content,
      'isError': isError ? 1 : 0,
      'fromRobot': fromRobot ? 1 : 0,
    };
  }

  factory ConsoleLog.fromMap(Map<String, dynamic> map) {
    return ConsoleLog(
      id: map['_id'],
      content: map['content'],
      dateTime: DateTime.parse(map['dateTime']),
      isError: map['isError'] == 1,
      fromRobot: map['fromRobot'] == 1,
    );
  }
}