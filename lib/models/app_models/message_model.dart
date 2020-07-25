class Message {
  final String text;
  final String senderId;
  final String receiverId;
  final int milliseconds;
  Message({this.text, this.senderId, this.receiverId, this.milliseconds});

  static Map<String, dynamic> toJson(Message message) {
    return {
      'text': message.text,
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'milliseconds': message.milliseconds,
    };
  }

  static Message fromJson(Map<String, dynamic> data) {
    return Message(
      text: data['text'],
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      milliseconds: data['milliseconds'],
    );
  }
}
