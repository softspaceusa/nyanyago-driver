import 'package:flutter/material.dart';
import 'package:nanny_components/widgets/nanny_text_forms.dart';

class MessageSendPanel extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onAttachmentPressed;
  final TextEditingController controller;
  
  const MessageSendPanel({
    super.key, 
    required this.onPressed, 
    required this.onAttachmentPressed, 
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 4,
          child: NannyTextForm(
            controller: controller,
          ),
        ),
        const SizedBox(width: 5),
        IconButton(
          onPressed: onAttachmentPressed, 
          icon: const Icon(Icons.attachment)
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: onPressed,
            child: const Icon(Icons.send_rounded)
          ),
        ),
      ],
    );
  }
}