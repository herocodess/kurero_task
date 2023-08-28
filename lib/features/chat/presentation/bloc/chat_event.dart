part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class FetchMessagesEvent extends ChatEvent {}

class SendMessagesEvent extends ChatEvent {
  final String message;
  final String email;

  SendMessagesEvent({
    required this.message,
    required this.email,
  });
}
