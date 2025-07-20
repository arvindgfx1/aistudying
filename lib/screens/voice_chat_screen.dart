import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'elevenlabs_tts_service.dart';
import 'openai_service.dart';
import 'voice_chat_screen.dart';
import 'chat_screen.dart';
import 'voice_model_screen.dart';

class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({Key? key}) : super(key: key);

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = '';
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isProcessing = false;
  VoiceModel _selectedVoice = voiceModels[0];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _isProcessing = false;
        _lastWords = '';
      });
      _speech.listen(
        onResult: (result) {
          setState(() {
            _lastWords = result.recognizedWords;
          });
          if (result.finalResult && _lastWords.isNotEmpty) {
            _speech.stop();
            setState(() => _isListening = false);
            _processAI(_lastWords);
          }
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 2),
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

  Future<void> _processAI(String userText) async {
    setState(() => _isProcessing = true);
    String aiResponse;
    try {
      aiResponse = await OpenAIService.getAIResponse(userMessage: userText);
    } catch (e) {
      aiResponse = 'Sorry, I could not process that.';
    }
    await ElevenLabsTTSService.speak(aiResponse);
    setState(() => _isProcessing = false);
    _startListening(); // <--- UNCOMMENT THIS LINE
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Voice model select button at the top right
            Positioned(
              right: 16,
              top: 16,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.record_voice_over, size: 20),
                label: Text(_selectedVoice.name),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                onPressed: () async {
                  final selected = await Navigator.of(context).push<VoiceModel>(
                    MaterialPageRoute(
                      builder: (context) => VoiceModelScreen(initialVoice: _selectedVoice),
                    ),
                  );
                  if (selected != null) {
                    setState(() => _selectedVoice = selected);
                  }
                },
              ),
            ),
            Center(
              child: _isListening
                  ? _buildAnimatedCircle()
                  : _isProcessing
                      ? _buildProcessingCircle()
                      : _buildIdleCircle(),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        backgroundColor:
                            _isListening ? Colors.red : Colors.white,
                        child: Icon(
                          Icons.mic,
                          color: _isListening ? Colors.white : Colors.black,
                          size: 32,
                        ),
                        onPressed: _isListening ? _stopListening : _startListening,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    },
                    child: const Text('Go to Chat Page'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCircle() {
    return RotationTransition(
      turns: _animation,
      child: ScaleTransition(
        scale: _animation,
        child: SizedBox(
          width: 180,
          height: 180,
          child: ClipOval(
            child: Image.asset(
              'assets/image/voice.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingCircle() {
    return Container(
      width: 180,
      height: 180,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildIdleCircle() {
    return SizedBox(
      width: 180,
      height: 180,
      child: ClipOval(
        child: Image.asset(
          'assets/image/voice.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
} 