import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'elevenlabs_tts_service.dart';
import 'openai_service.dart';

class CameraTutorScreen extends StatefulWidget {
  @override
  _CameraTutorScreenState createState() => _CameraTutorScreenState();
}

class _CameraTutorScreenState extends State<CameraTutorScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _aiExplanation;
  bool _loading = false;
  CameraController? _cameraController;
  XFile? _capturedImage;
  List<CameraDescription>? _cameras;
  bool _cameraInitialized = false;
  // Speech-to-text
  late stt.SpeechToText _speech;
  bool _isListening = false;
  // Text-to-speech

  @override
  void initState() {
    super.initState();
    _initCamera();
    _speech = stt.SpeechToText();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(_cameras![0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {
        _cameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final image = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = image;
      });
    }
  }

  // Imgur upload helper
  Future<String?> uploadImageToImgur(String imagePath) async {
    final url = Uri.parse('https://api.imgur.com/3/image');
    final imageBytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(imageBytes);

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Client-ID YOUR_IMGUR_CLIENT_ID', // TODO: Replace with your Imgur Client ID
      },
      body: {
        'image': base64Image,
        'type': 'base64',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['link'];
    } else {
      return null;
    }
  }

  Future<void> _getAIExplanationFromImage() async {
    if (_capturedImage == null) return;
    setState(() {
      _loading = true;
      _aiExplanation = null;
    });
    try {
      final imageUrl = await uploadImageToImgur(_capturedImage!.path);
      if (imageUrl == null) {
        setState(() {
          _aiExplanation = 'Failed to upload image to Imgur.';
          _loading = false;
        });
        return;
      }
      final response = await OpenAIService.getAIResponse(
        userMessage: 'Describe this image: $imageUrl',
      );
      setState(() {
        _aiExplanation = response;
      });
    } catch (e) {
      setState(() {
        _aiExplanation = 'Failed to get AI explanation: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
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

  Future<void> _speakAIReply() async {
    if (_aiExplanation != null && _aiExplanation!.isNotEmpty) {
      await ElevenLabsTTSService.speak(_aiExplanation!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📷 Camera Tutor'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_cameraInitialized)
              Column(
                children: [
                  AspectRatio(
                    aspectRatio: _cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraController!),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text('Capture Image'),
                    onPressed: _cameraInitialized ? _captureImage : null,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: Icon(Icons.visibility),
                    label: Text('Send Current Frame to AI'),
                    onPressed: _loading ? null : () async {
                      setState(() {
                        _loading = true;
                        _aiExplanation = null;
                      });
                      try {
                        final image = await _cameraController!.takePicture();
                        final imageUrl = await uploadImageToImgur(image.path);
                        if (imageUrl == null) {
                          setState(() {
                            _aiExplanation = 'Failed to upload image to Imgur.';
                            _loading = false;
                          });
                          return;
                        }
                        final response = await OpenAIService.getAIResponse(
                          userMessage: 'Describe this image: $imageUrl',
                        );
                        setState(() {
                          _aiExplanation = response;
                        });
                      } catch (e) {
                        setState(() {
                          _aiExplanation = 'Failed to get AI explanation: $e';
                        });
                      } finally {
                        setState(() {
                          _loading = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            if (_capturedImage != null) ...[
              const SizedBox(height: 12),
              Image.file(File(_capturedImage!.path), height: 200),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: Icon(Icons.psychology),
                label: Text('Get AI Explanation for Image'),
                onPressed: _loading ? null : _getAIExplanationFromImage,
              ),
            ],
            const Divider(height: 32),
            Text('Or paste/type text to get an AI explanation:'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    minLines: 2,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter or paste text here...',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  color: _isListening ? Colors.red : Colors.grey,
                  onPressed: _isListening ? _stopListening : _startListening,
                  tooltip: _isListening ? 'Stop Listening' : 'Speak',
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: Icon(Icons.psychology),
              label: Text('Get AI Explanation for Text'),
              onPressed: _loading
                  ? null
                  : () async {
                      final text = _textController.text.trim();
                      if (text.isEmpty) return;
                      setState(() {
                        _loading = true;
                        _aiExplanation = null;
                      });
                      try {
                        final response = await OpenAIService.getAIResponse(userMessage: 'Explain this: ' + text);
                        setState(() {
                          _aiExplanation = response;
                        });
                      } catch (e) {
                        setState(() {
                          _aiExplanation = 'Failed to get AI explanation: $e';
                        });
                      } finally {
                        setState(() {
                          _loading = false;
                        });
                      }
                    },
            ),
            const SizedBox(height: 24),
            if (_loading) CircularProgressIndicator(),
            if (_aiExplanation != null && !_loading)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _aiExplanation!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: Icon(Icons.volume_up),
                    label: Text('Listen to AI Reply'),
                    onPressed: _speakAIReply,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
} 