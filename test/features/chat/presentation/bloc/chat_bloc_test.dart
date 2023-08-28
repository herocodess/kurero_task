import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kurero_task/core/models/user_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:kurero_task/core/models/message_model.dart';
import 'package:kurero_task/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:path_provider/path_provider.dart';

class MockHiveBox extends Mock implements Box<MessageModel> {}

class MockMessageModelAdapter extends Mock implements MessageModelAdapter {}

class MockUserAdapter extends Mock implements UserAdapter {}

void main() {
  late ChatBloc chatBloc;
  late MessageModel messageModel;
  late Box<MessageModel> mockMessageBox;
  setUpAll(() async {
    // Initialize Hive
    TestWidgetsFlutterBinding.ensureInitialized();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async {
      return '.';
    });
    final directory = await getApplicationDocumentsDirectory();

    Hive
      ..init(directory.path)
      ..registerAdapter(MessageModelAdapter())
      ..registerAdapter(UserAdapter());

    await Hive.openBox<MessageModel>('chat_messages');
  });
  group('ChatBloc ->', () {
    setUp(() async {
      chatBloc = ChatBloc();

      mockMessageBox = MockHiveBox();
      messageModel = MessageModel(
        text: 'Hello!',
        timestamp: DateTime.now(),
        sender: User(
          name: 'User1',
          email: 'user1@test.com',
          avatarUrl: 'dummy avatar link',
        ),
      );

      reset(mockMessageBox);
    });

    test('initial state is correct', () {
      expect(chatBloc.state, const TypeMatcher<ChatInitial>());
    });

    blocTest<ChatBloc, ChatState>(
      'emits updated state when [SendMessageEvent] is added',
      build: () => chatBloc,
      act: (bloc) async {
        bloc.add(
          SendMessagesEvent(
              message: messageModel.text, email: messageModel.sender.email),
        );
        await mockMessageBox.add(messageModel);
      },
      expect: () => <TypeMatcher<ChatState>>[
        const TypeMatcher<SendMessageSuccessState>(),
        const TypeMatcher<ChatLoadedState>(),
      ],
      errors: () => [
        isA<SendMessageErrorState>(),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'emits updated state when [FetchMessagesEvent] is added',
      build: () => chatBloc,
      act: (bloc) => bloc.add(FetchMessagesEvent()),
      expect: () => <TypeMatcher<ChatState>>[
        const TypeMatcher<ChatLoadingState>(),
        const TypeMatcher<ChatLoadedState>(),
      ],
    );

    tearDown(() {
      chatBloc.close();
    });
  });
}
