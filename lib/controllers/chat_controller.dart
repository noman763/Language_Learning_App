import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/chat_message.dart';

class ChatController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var messages = <ChatMessage>[].obs;
  var isTyping = false.obs;

  void initChat(String tutorName, String tutorFlag) {
    if (messages.isEmpty) {
      messages.add(ChatMessage(
        text: "Hello! I am $tutorName $tutorFlag. I'm here to help you practice and learn.",
        isMe: false,
        timestamp: DateTime.now(),
      ));
    }
  }

  void sendMessage() {
    String text = textController.text.trim();
    if (text.isEmpty) return;

    messages.add(ChatMessage(
      text: text,
      isMe: true,
      timestamp: DateTime.now(),
    ));

    textController.clear();
    scrollToBottom();
    getAutoResponse(text);
  }

  void getAutoResponse(String userText) {
    isTyping.value = true;

    Future.delayed(const Duration(milliseconds: 1500), () {
      String input = userText.toLowerCase();
      String response = "That's interesting! Let's practice more.";

      if (input.contains("hello") || input.contains("hi")) {
        response = "Hi there! Ready to start our session?";
      } else if (input.contains("how are you")) {
        response = "I'm doing great! How about you?";
      }

      messages.add(ChatMessage(
        text: response,
        isMe: false,
        timestamp: DateTime.now(),
      ));

      isTyping.value = false;
      scrollToBottom();
    });
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}