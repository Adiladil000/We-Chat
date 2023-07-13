class Message {
  Message({
    required this.msg,
    required this.read,
    required this.toId,
    required this.type,
    required this.fromId,
    required this.sent,
  });
  late final String msg;
  late final String read;
  late final String toId;
  late final String fromId;
  late final String sent;
  late final Type type;

  Message.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    read = json['read'];
    toId = json['toId'];
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    fromId = json['fromId'];
    sent = json['sent'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['read'] = read;
    data['toId'] = toId;
    data['type'] = type.name;
    data['fromId'] = fromId;
    data['sent'] = sent;
    return data;
  }
}

enum Type { text, image }
