import 'package:flutter/material.dart';
import 'package:kurero_task/core/helper/extensions.dart';
import 'package:kurero_task/core/helper/helper.dart';
import 'package:kurero_task/core/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel messageModel;
  final bool isSender;
  final VoidCallback? onQuoteReply;

  const MessageBubble({
    super.key,
    required this.messageModel,
    required this.isSender,
    this.onQuoteReply,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTimestamp = Helper.formatTimeStamp(messageModel.timestamp);

    return Dismissible(
      key: Key(messageModel.timestamp.toString()), // Use a unique key
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16.0),
        child: const Icon(Icons.reply),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Trigger the quote-reply action
          if (onQuoteReply != null) {
            onQuoteReply!();
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isSender)
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.grey,
                      child: Text(
                        Helper.getUserInitialsFromEmail(
                          messageModel.sender.email,
                        ).toTitleCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: isSender ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        messageModel.text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (isSender)
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.blue,
                      child: Text(
                        Helper.getUserInitialsFromEmail(
                          messageModel.sender.email,
                        ).toTitleCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4.0),
              Text(
                formattedTimestamp,
                style: const TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
