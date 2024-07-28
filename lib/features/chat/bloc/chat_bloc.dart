import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:client/features/chat/models/chat_message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatNewPromptEvent>(chatNewPromptEvent);
    on<ChatNewContentGeneratedEvent>(chatNewContentGeneratedEvent);

    _setupSocket();
  }

  List<ChatMessageModel> cachedMessages = [];
  late IO.Socket socket;

  void _setupSocket() {
    socket = IO.io('http://localhost:4000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('connected to socket server');
    });

    socket.onDisconnect((_) {
      print('disconnected from socket server');
    });

    socket.on('newContent', (data) {
      add(ChatNewContentGeneratedEvent(content: data['content']));
    });
  }

  FutureOr<void> chatNewPromptEvent(
      ChatNewPromptEvent event, Emitter<ChatState> emit) async {
    emit(ChatNewMessageGeneratingLoadingState());
    try {
      ChatMessageModel newMessage =
          ChatMessageModel(role: 'user', content: event.prompt);
      cachedMessages.add(newMessage);
      emit(ChatNewMessageGeneratedState());

      socket.emit('newPrompt', {
        'prompt': event.prompt,
        'socketId': socket.id,
      });
    } catch (e) {
      log(e.toString());
      emit(ChatNewMessageGeneratingErrorState());
    }
  }

  FutureOr<void> chatNewContentGeneratedEvent(
      ChatNewContentGeneratedEvent event, Emitter<ChatState> emit) {
    try {
      ChatMessageModel newMessage =
          ChatMessageModel(role: 'assistant', content: event.content);
      cachedMessages.add(newMessage);
      emit(ChatNewMessageGeneratedState());
    } catch (e) {
      log(e.toString());
      emit(ChatNewMessageGeneratingErrorState());
    }
  }
}
