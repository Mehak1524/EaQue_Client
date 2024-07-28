import 'package:client/services/socket_service.dart';

class ChatRepository {
  final SocketService socketService;

  ChatRepository({required this.socketService});

  void sendPrompt(String prompt) {
    socketService.sendPrompt(prompt);
  }
}
