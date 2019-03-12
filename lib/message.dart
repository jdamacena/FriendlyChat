import 'package:uuid/uuid.dart';

class Message {
  final String senderId;
  final String threadId;
  final String message;

  String messageId = Uuid().v4();
  int timestamp = new DateTime.now().millisecondsSinceEpoch;

  Message({
    this.senderId = '',
    this.threadId = '',
    this.message = '',
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    Message tmpMessage = Message(
        senderId: json['sender_id'],
        threadId: json['thread_id'],
        message: json['message']);

    tmpMessage.messageId = json['message_id'];
    tmpMessage.timestamp = json['timestamp'];

    return tmpMessage;
  }
}
