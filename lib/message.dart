class Message {
  final String guid;
  final String name;
  final String text;
  final String timestamp;
  final bool incoming;

  Message({this.guid = '', this.name = '', this.text = '', this.timestamp = '', this.incoming = false});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      guid: json['guid'],
      name: json['name'],
      text: json['name'],
      timestamp: json['timestamp'],
      incoming: json['incoming'],
    );
  }

  List<Message> listFromJson(Map<String, dynamic> json) {
    var json2 = json['root'];
    List<Message> messagesList = new List<Message>();

    for (int i = 0; i < json2.length; i++) {
      var messageMap = json2[i];
      var message = Message.fromJson(messageMap);
      messagesList.add(message);
    }

    return messagesList;
  }
}
