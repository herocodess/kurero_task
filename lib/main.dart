import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kurero_task/core/models/message_model.dart';
import 'package:kurero_task/core/models/user_model.dart';
import 'package:kurero_task/features/auth/presentation/views/login_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kurero_task/features/chat/presentation/bloc/chat_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  runApp(const MyApp());
}

Future<void> initHive() async {
  final directory = await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapter(MessageModelAdapter())
    ..registerAdapter(UserAdapter());

  await Hive.openBox<MessageModel>('chat_messages');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(),
          ),
        ],
        child: LoginScreen(),
      ),
    );
  }
}
