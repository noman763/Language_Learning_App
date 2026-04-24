import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  ChatMessage({required this.text, required this.isMe});
}

class ChatScreen extends StatefulWidget {
  final String tutorName;
  final String tutorFlag;

  const ChatScreen({super.key, required this.tutorName, required this.tutorFlag});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      ChatMessage(
          text: "Hello! I am ${widget.tutorName} ${widget.tutorFlag}. I'm here to help you practice and learn. What's on your mind?",
          isMe: false
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    String userText = _controller.text.trim();
    setState(() {
      _messages.add(ChatMessage(text: userText, isMe: true));
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();
    _getAutoResponse(userText);
  }

  void _getAutoResponse(String userText) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      String input = userText.toLowerCase();
      String response = "";

      if (input.contains("hello") || input.contains("hi") || input.contains("hey")) {
        response = "Hi there! Ready to start our session? What language topic should we cover?";
      } else if (input.contains("how are you")) {
        response = "I'm doing great! Ready to help you master some new phrases. How about you?";
      } else if (input.contains("help") || input.contains("teach")) {
        response = "Of course! I can help with grammar, vocabulary, or just general conversation. Which one do you prefer?";
      } else if (input.contains("thank")) {
        response = "You're very welcome! I'm happy to help. Anything else?";
      } else if (input.contains("urdu")) {
        response = "Urdu is a beautiful language! 'Assalam-o-Alaikum' is a great way to start. Want to learn more?";
      } else if (input.contains("english")) {
        response = "Sure! We can practice English conversation. Tell me about your day!";
      } else if (input.contains("spanish")) {
        response = "¡Hola! Spanish is very rhythmic. Let's start with '¿Cómo estás?' (How are you?)";
      } else if (input.contains("bye") || input.contains("goodbye")) {
        response = "Goodbye! It was a great session. Keep practicing and see you soon!";
      } else if (userText.length < 4) {
        response = "I see. Can you tell me a bit more so I can guide you better?";
      } else {
        response = "That's an interesting point! As your tutor, I suggest we practice using that in a complete sentence. Try it!";
      }

      setState(() {
        _messages.add(ChatMessage(text: response, isMe: false));
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.accentPrimary,
              child: Text(widget.tutorFlag, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.tutorName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("Online", style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                final msg = _messages[index];
                return _buildMessageBubble(msg.text, msg.isMe);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.accentPrimary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(20),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Text(
            text,
            style: TextStyle(color: isMe ? Colors.white : AppColors.textPrimary, fontSize: 15, height: 1.4)
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text("typing...", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: "Write to ${widget.tutorName}...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: AppColors.background.withOpacity(0.5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send_rounded, color: AppColors.accentPrimary, size: 28),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}