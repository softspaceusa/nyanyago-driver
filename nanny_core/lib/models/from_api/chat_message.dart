class ChatMessage {
    ChatMessage({
        required this.idChat,
        required this.msg,
        required this.msgType,
        required this.timestampSend,
        required this.isMe,
    });

    final int idChat;
    final String msg;
    int msgType;
    final double timestampSend;
    final bool isMe;

    factory ChatMessage.fromJson(Map<String, dynamic> json){ 
        return ChatMessage(
          idChat: json["id_chat"] ?? 0,
          msg: json["msg"] ?? "",
          msgType: json["msgType"] ?? 0,
          timestampSend: (json["timestamp_send"] as num?)?.toDouble() ?? 0,
          isMe: json["isMe"] ?? false,
        );
    }

    Map<String, dynamic> toJson() => {
      "id_chat": idChat,
      "msg": msg,
      "msgType": msgType,
      // "timestamp_send": timestampSend,
      "isMe": isMe,
    };

}
