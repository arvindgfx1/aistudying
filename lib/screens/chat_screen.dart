import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'elevenlabs_tts_service.dart';
import 'openai_service.dart';
import 'voice_chat_screen.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String? initialMessage;
  ChatScreen({this.initialMessage, Key? key}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  late types.User _user;
  late types.User _aiUser;
  final TextEditingController _textController = TextEditingController();
  String _username = 'Student';
  // final SpeechToText _speechToText = SpeechToText();
  // final FlutterTts _flutterTts = FlutterTts();
  // bool _speechEnabled = false;
  // bool _isListening = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _user = types.User(id: FirebaseAuth.instance.currentUser?.uid ?? '1', firstName: _username);
    _aiUser = const types.User(id: '2', firstName: 'AI Tutor');
    // _initializeSpeech();
    // _initializeTTS();
    _speech = stt.SpeechToText();
    _addWelcomeMessage();
    if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
      Future.delayed(Duration.zero, () {
        _handleSubmitted(types.PartialText(text: widget.initialMessage!));
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadUsername() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data()?['username'] != null) {
          setState(() {
            _username = doc.data()!['username'];
            _user = types.User(id: user.uid, firstName: _username);
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading username: $e');
    }
  }

  // Future<void> _initializeSpeech() async {
  //   _speechEnabled = await _speechToText.initialize();
  // }

  // Future<void> _initializeTTS() async {
  //   await _flutterTts.setLanguage("en-US");
  //   await _flutterTts.setSpeechRate(0.5);
  //   await _flutterTts.setVolume(1.0);
  // }

  void _addWelcomeMessage() {
    final welcomeMessage = types.TextMessage(
      author: _aiUser,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: '''Hello! I'm your AI Study Assistant. 👋

I can help you with:
• 📚 Subject explanations
• 🧮 Math problems
• 📖 Literature analysis
• 🔬 Science concepts
• And much more!

Just ask me anything!''',
    );
    _messages.insert(0, welcomeMessage);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message.text,
    );

    _addMessage(textMessage);

    // Show typing indicator
    final typingMessage = types.TextMessage(
      author: _aiUser,
      id: 'typing',
      text: '...',
    );
    _addMessage(typingMessage);

    // Call OpenAIService for real AI response
    String aiResponse;
    try {
      aiResponse = await OpenAIService.getAIResponse(userMessage: message.text);
      if (aiResponse.trim() == "***") {
        aiResponse = "Sorry, I can't answer that question.";
      }
      // Custom response for creator questions
      final lower = message.text.toLowerCase();
      if (lower.contains('who created you') ||
          lower.contains('who made you') ||
          lower.contains('who is your creator') ||
          lower.contains('who developed you') ||
          lower.contains('tumhe kisne banaya') ||
          lower.contains('kisne banaya') ||
          lower.contains('creator') ||
          lower.contains('banaya hai')) {
        aiResponse = '''Who Created Me?\n\nBrand Name: ARVIND GFX\n\nCreated by Team: CodeCraft\n\nFounded by: A passionate team of tech creators and innovators\n\nPurpose: To make AI-powered learning tools easily accessible and useful for every student, helping them learn smarter and faster.''';
      }
    } catch (e) {
      aiResponse = 'Failed to get AI response: $e';
    }

    // Remove typing indicator
    setState(() {
      _messages.removeWhere((message) => message.id == 'typing');
    });

    final aiMessage = types.TextMessage(
      author: _aiUser,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: aiResponse,
    );

    _addMessage(aiMessage);

    // Speak the AI response automatically
    await ElevenLabsTTSService.speak(aiResponse);
    _startListening();
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
          });
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US',
        cancelOnError: true,
        partialResults: true,
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE3F0FF), Color(0xFFF8FBFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              // Header with AI status/profile
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.smart_toy, color: Theme.of(context).colorScheme.primary, size: 28),
                      radius: 24,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'AI Study Assistant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Online',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    // Hear button
          IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.white, size: 28),
                      tooltip: 'Hear last AI message',
            onPressed: () async {
                        try {
                          final aiMsg = _messages.firstWhere(
                            (m) => m.author.id == _aiUser.id && m is types.TextMessage,
                          ) as types.TextMessage;
                          await ElevenLabsTTSService.speak(aiMsg.text);
                        } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No AI message to play.')),
                );
              }
            },
          ),
        ],
      ),
              ),
              // Chat area
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUser = message.author.id == _user.id;
                    final isAI = message.author.id == _aiUser.id;
                    final time = message is types.TextMessage
                        ? DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(int.tryParse(message.id) ?? DateTime.now().millisecondsSinceEpoch))
                        : '';
                    return Row(
                      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (isAI)
                          Padding(
                            padding: const EdgeInsets.only(right: 8, bottom: 4),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              backgroundImage: AssetImage('assets/image/ai.png'),
                              radius: 18,
                            ),
                          ),
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isUser ? Colors.blue[600] : Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(18),
                                topRight: const Radius.circular(18),
                                bottomLeft: Radius.circular(isUser ? 18 : 4),
                                bottomRight: Radius.circular(isUser ? 4 : 18),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message is types.TextMessage ? message.text : '',
                                  style: TextStyle(
                                    color: isUser ? Colors.white : Colors.black87,
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  time,
                                  style: TextStyle(
                                    color: isUser ? Colors.white70 : Colors.black38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isUser)
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 4),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue[100],
                              child: Icon(Icons.person, color: Colors.blue[700], size: 22),
                              radius: 18,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              // Typing indicator
              if (_messages.isNotEmpty && _messages.first.id == 'typing')
                Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        backgroundImage: AssetImage('assets/image/ai.png'),
                        radius: 16,
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 36,
                        height: 16,
                        child: Row(
                          children: [
                            _buildDot(0),
                            _buildDot(1),
                            _buildDot(2),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('AI is typing...', style: TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                ),
              // Input bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
          ),
        ],
      ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                color: _isListening ? Colors.red : Colors.grey,
                onPressed: _isListening ? _stopListening : _startListening,
                tooltip: _isListening ? 'Stop Listening' : 'Speak',
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything about your studies...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        _handleSubmitted(types.PartialText(text: text));
                        _textController.clear();
                      }
                    },
                  ),
                ),
              ),
                    // Voice-to-voice button
              IconButton(
                      icon: Image.asset(
                        'assets/image/voiceicon.png',
                        width: 26,
                        height: 26,
                      ),
                      tooltip: 'Voice to Voice',
                onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const VoiceChatScreen()),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                  final text = _textController.text.trim();
                  if (text.isNotEmpty) {
                    _handleSubmitted(types.PartialText(text: text));
                    _textController.clear();
                  }
                },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.send, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.blue[(index + 1) * 200],
        shape: BoxShape.circle,
      ),
    );
  }
}