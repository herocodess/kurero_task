// ignore_for_file: depend_on_referenced_packages

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kurero_task/core/helper/helper.dart';
import 'package:kurero_task/core/models/message_model.dart';
import 'package:kurero_task/core/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final messageBox = Hive.box<MessageModel>('chat_messages');

  ChatBloc() : super(ChatInitial()) {
    on<SendMessagesEvent>((event, emit) async {
      try {
        final newMessage = MessageModel(
          text: event.message,
          timestamp: DateTime.now(),
          sender: User(
            name: 'User${Helper.getFirstNumber(event.email)}',
            email: event.email,
            avatarUrl: Helper.defaultAvatarUrl,
          ),
        );
        await messageBox.add(newMessage);
        final updatedMessages = [
          ...(state as ChatLoadedState).messages,
          newMessage
        ];
        emit(SendMessageSuccessState());
        emit(ChatLoadedState(messages: updatedMessages));
      } catch (e) {
        emit(SendMessageErrorState(message: e.toString()));
      }
    });
    on<FetchMessagesEvent>((event, emit) {
      emit(ChatLoadingState());
      try {
        final messages = messageBox.values.toList();
        emit(ChatLoadedState(messages: messages));
      } catch (e) {
        emit(ChatErrorState(message: e.toString()));
      }
    });
  }
}
