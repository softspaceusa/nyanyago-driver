import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/view_models/direct_vm.dart';
import 'package:nanny_components/base_views/views/document_view.dart';
import 'package:nanny_components/base_views/views/video_view.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/message_send_panel.dart';
import 'package:nanny_core/models/from_api/chat_message.dart';
import 'package:nanny_core/nanny_core.dart';

class DirectView extends StatefulWidget {
  final int idChat;
  final String? name;

  const DirectView({super.key, required this.idChat, this.name});

  @override
  State<DirectView> createState() => _DirectViewState();
}

class _DirectViewState extends State<DirectView> {
  late DirectVM vm;
  static const double sideMargin = 100;
  static const double margin = 20;
  static const double messageSpacing = 10;

  @override
  void initState() {
    super.initState();
    vm = DirectVM(context: context, update: setState, idChat: widget.idChat);
  }

  @override
  void dispose() {
    super.dispose();
    vm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NannyAppBar(
          title: widget.name ?? "Чат",
          isTransparent: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: RequestLoader(
                request: vm.messagesRequest,
                completeView: (context, data) {
                  vm.messages ??= data!.messages;

                  return ListView(
                    shrinkWrap: true,
                    reverse: true,
                    children: vm.messages!.map((e) => directPanel(e)).toList(),
                  );
                },
                errorView: (context, error) =>
                    ErrorView(errorText: error.toString()),
              ),
            ),
            NannyBottomSheet(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: MessageSendPanel(
                  onPressed: vm.sendTextMessage,
                  onAttachmentPressed: vm.attachImage,
                  controller: vm.textController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget directPanel(ChatMessage message) {
    return Container(
        margin: EdgeInsets.only(
            left: message.isMe ? sideMargin : margin,
            right: message.isMe ? margin : sideMargin,
            top: messageSpacing,
            bottom: messageSpacing),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: message.isMe ? NannyTheme.primary : NannyTheme.secondary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(blurRadius: 1, color: Colors.black)]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Align(
              alignment: Alignment.centerLeft,
              child: decideMessageContent(message)),
          Align(
              alignment: Alignment.centerRight,
              child: Text(
                  DateFormat("HH:mm").format(
                      DateTime.fromMillisecondsSinceEpoch(
                          (message.timestampSend * 1000).toInt())),
                  style: TextStyle(
                      color: message.isMe ? NannyTheme.secondary : null)))
        ]));
  }

  Widget decideMessageContent(ChatMessage message) {
    var textStyle =
        TextStyle(color: message.isMe ? NannyTheme.secondary : null);

    if (message.msg.split('.').last == "gif") message.msgType = 2;

    return switch (message.msgType) {
      1 => Text(message.msg, style: textStyle),
      2 => GestureDetector(
          onTap: () => _openImageView(message.msg),
          child: NetImage(
            radius: 20,
            url: message.msg,
            fitToShortest: false,
          ),
        ),
      3 => GestureDetector(
          onTap: () => vm.navigateToView(VideoView(url: message.msg)),
          child: Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: NannyTheme.onSecondary),
              child: const Center(
                  child: Icon(Icons.play_circle_outline_rounded,
                      color: NannyTheme.secondary, size: 50)))),
      4 => TextButton(
          onPressed: () => _openPdfFile(message.msg),
          child: Text(message.msg.split('/').last,
              style: const TextStyle(color: NannyTheme.lightGreen))),
      _ => const Placeholder()
    };
  }

  void _openImageView(String url) {
    showDialog(
      context: context,
      builder: (dContext) => Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
              maxScale: 5,
              child: NetImage(
                url: url,
                fitToShortest: false,
              )),
          Align(
            alignment: Alignment.topRight,
            child: Material(
              borderRadius:
                  const BorderRadius.only(bottomLeft: Radius.circular(20)),
              child: IconButton(
                  onPressed: () => Navigator.pop(dContext),
                  icon: const Icon(Icons.close)),
            ),
          ),
        ],
      ),
    );
  }

  void _openPdfFile(String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DocumentView(url: url)));
  }
}
