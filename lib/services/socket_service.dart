import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void initSocket() {
    socket = IO.io('http://localhost:4000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('connected to socket server');
    });

    socket.onDisconnect((_) {
      print('disconnected from socket server');
    });
  }

  void sendPrompt(String prompt) {
    socket.emit('newPrompt', {
      'prompt': prompt,
      'socketId': socket.id,
    });
  }

  void onNewContent(Function(String) callback) {
    socket.on('newContent', (data) {
      String content = data['content'];
      callback(content);
    });
  }
}
