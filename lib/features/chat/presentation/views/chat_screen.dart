// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kurero_task/core/models/message_model.dart';
import 'package:kurero_task/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:kurero_task/features/chat/presentation/widgets/message_bubble_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.email,
  });
  final String email;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> messages = [];
  MessageModel? selectedMessage, repliedMessage;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Kurero'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: BlocConsumer<ChatBloc, ChatState>(
          bloc: BlocProvider.of<ChatBloc>(context)..add(FetchMessagesEvent()),
          listener: (context, state) {
            if (state is SendMessageSuccessState) {
            } else if (state is SendMessageErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is ChatErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is ChatLoadedState) {
              messages = state.messages;
            }
          },
          builder: (context, state) {
            if (messages.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text('No messages yet'),
                  ),
                  const Spacer(),
                  _MessageInputWidget(
                    email: widget.email,
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isSender = message.sender.email == widget.email;
                      return Column(
                        children: [
                          if (selectedMessage != message)
                            MessageBubble(
                              messageModel: message,
                              isSender: isSender,
                              onQuoteReply: () {
                                setState(() {
                                  selectedMessage = message;
                                });
                              },
                            ),
                          const Divider(),
                        ],
                      );
                    },
                    itemCount: messages.length,
                  ),
                ),
                _MessageInputWidget(
                  email: widget.email,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MessageInputWidget extends StatefulWidget {
  _MessageInputWidget({
    required this.email,
  });
  final String email;
  @override
  _MessageInputWidgetState createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<_MessageInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration:
                  const InputDecoration(labelText: 'Enter your message'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final message = _controller.text;
              if (message.isNotEmpty) {
                chatBloc.add(
                    SendMessagesEvent(message: message, email: widget.email));
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
