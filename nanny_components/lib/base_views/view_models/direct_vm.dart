import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/view_model_base.dart';
import 'package:nanny_core/api/api_models/messages_request.dart';
import 'package:nanny_core/api/web_sockets/nanny_web_socket.dart';
import 'package:nanny_core/models/from_api/chat_message.dart';
import 'package:nanny_core/models/from_api/direct_chat.dart';
import 'package:nanny_core/nanny_core.dart';

class DirectVM extends ViewModelBase {
  DirectVM({
    required super.context, 
    required super.update,
    required this.idChat,
  }) {
    messagesRequest = _initDirect();
  }

  final int idChat;
  NannyWebSocket get chat => NannyGlobals.chatsSocket;

  late final StreamSubscription sub;

  final TextEditingController textController = TextEditingController();

  bool loading = false;
  late Future<ApiResponse<DirectChat>> messagesRequest;
  List<ChatMessage>? messages;

  Future<ApiResponse<DirectChat>> _initDirect() async {
    sub = chat.stream.listen(chatStreamCallback);

    return NannyChatsApi.getMessages(
      MessagesRequest(
        idChat: idChat, 
        offset: 0, 
        limit: 50
      ),
    );
  }

  void dispose() {
    sub.cancel();
  }

  void chatStreamCallback(dynamic data) {
    Map<String, dynamic> json = jsonDecode(data);
    ChatMessage msg = ChatMessage.fromJson(json);

    messages?.insert(0, msg);
    update(() {});
  }

  void sendTextMessage() async {
    if(textController.text.trim().isEmpty) return;

    _sendMessage(
      ChatMessage(
        idChat: idChat,
        msg: textController.text, 
        msgType: 1, 
        // timestampSend: _getCurrentTimeInSeconds(), 
        timestampSend: 0, 
        isMe: true
      ),
    );

    textController.clear();
  }

  void attachImage() async {
    XFile? file = await ImagePicker().pickMedia();

    if(file == null) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, true);
    var fileUpload = await NannyFilesApi.uploadFiles([file]);

    if(!context.mounted) return;
    if(!fileUpload.success) {
      LoadScreen.showLoad(context, false);
      return;
    }

    _sendMessage(
      ChatMessage(
        idChat: idChat, 
        msg: fileUpload.response!.paths.first,
        msgType: fileUpload.response!.types.first,
        // timestampSend: _getCurrentTimeInSeconds(), 
        timestampSend: 0, 
        isMe: true
      )
    );

    LoadScreen.showLoad(context, false);
  }

  void _sendMessage(ChatMessage msg) {
    chat.sink.add( jsonEncode(msg) );
  }
}