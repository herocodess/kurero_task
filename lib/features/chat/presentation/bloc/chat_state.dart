// ignore_for_file: must_be_immutable

part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoadingState extends ChatState {}

final class ChatLoadedState extends ChatState {
  List<MessageModel> messages;

  ChatLoadedState({required this.messages});
}

final class ChatErrorState extends ChatState {
  final String message;

  ChatErrorState({required this.message});
}

final class SendMessageLoadingState extends ChatState {}

final class SendMessageSuccessState extends ChatState {}

final class SendMessageErrorState extends ChatState {
  final String message;

  SendMessageErrorState({required this.message});
}
