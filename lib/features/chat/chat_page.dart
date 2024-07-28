import 'package:client/design/app_colors.dart';
import 'package:client/features/chat/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatBloc chatBloc = ChatBloc();
  TextEditingController controller = TextEditingController();
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    connectToSocket();
  }

  void connectToSocket() {
    socket = IO.io('http://localhost:4000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('Socket connected');
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.on('newContent', (data) {
      String content = data['content'];
      chatBloc.add(ChatNewContentGeneratedEvent(content: content));
    });

    socket.on('geminiResponse', (data) {
      String content = data;
      chatBloc.add(ChatNewContentGeneratedEvent(content: content));
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "EaQue",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.greyBdColor,
          ),
        ),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 12),
                    itemCount: chatBloc.cachedMessages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color:
                              chatBloc.cachedMessages[index].role == 'assistant'
                                  ? AppColors.messageBgColor
                                  : Colors.transparent,
                        ),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 8,
                          top: 8,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            chatBloc.cachedMessages[index].role == 'assistant'
                                ? Container(
                                    height: 32,
                                    width: 32,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/EaQue_Logo.jpg"),
                                            fit: BoxFit.cover)),
                                  )
                                : Container(
                                    height: 32,
                                    width: 32,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                AssetImage("assets/mehak.jpg"),
                                            fit: BoxFit.cover)),
                                  ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                chatBloc.cachedMessages[index].content,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      promptContainer("What were the total sales in Q1?"),
                      promptContainer(
                          "Which product had the highest sales in Q2?"),
                      promptContainer(
                          "Can you provide the sales breakdown by region for Q3?"),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.yellowBgColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  margin: const EdgeInsets.only(
                    bottom: 40,
                    left: 16,
                    right: 16,
                    top: 6,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          cursorColor: AppColors.greyBdColor,
                          decoration: InputDecoration(
                            hintText: "Enter a Query!",
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            filled: false,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      InkWell(
                        onTap: () {
                          if (controller.text.isNotEmpty) {
                            String text = controller.text;
                            controller.clear();
                            chatBloc.add(ChatNewPromptEvent(prompt: text));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget promptContainer(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.5),
        color: AppColors.yellowBgColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          chatBloc.add(ChatNewPromptEvent(prompt: text));
        },
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
