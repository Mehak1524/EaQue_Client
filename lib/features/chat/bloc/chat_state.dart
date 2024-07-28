part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatNewMessageGeneratingLoadingState extends ChatState {}

class ChatNewMessageGeneratedState extends ChatState {}

class ChatNewMessageGeneratingErrorState extends ChatState {}
