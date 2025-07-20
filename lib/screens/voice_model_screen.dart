import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceModel {
  final String name;
  final String gender;
  final String id;
  final String description;
  final String previewAsset;
  const VoiceModel({
    required this.name,
    required this.gender,
    required this.id,
    required this.description,
    required this.previewAsset,
  });
}

const List<VoiceModel> voiceModels = [
  VoiceModel(name: 'Sophie', gender: 'Female', id: 'sophie', description: 'Warm and friendly', previewAsset: 'assets/audio/Sophie.mp3'),
  VoiceModel(name: 'Emma', gender: 'Female', id: 'emma', description: 'Clear and confident', previewAsset: 'assets/audio/Emma.mp3'),
  VoiceModel(name: 'Olivia', gender: 'Female', id: 'olivia', description: 'Calm and soothing', previewAsset: 'assets/audio/Olivia.mp3'),
  VoiceModel(name: 'James', gender: 'Male', id: 'james', description: 'Deep and thoughtful', previewAsset: 'assets/audio/James.mp3'),
  VoiceModel(name: 'Liam', gender: 'Male', id: 'liam', description: 'Bright and energetic', previewAsset: 'assets/audio/Liam.mp3'),
  VoiceModel(name: 'Noah', gender: 'Male', id: 'noah', description: 'Friendly and engaging', previewAsset: 'assets/audio/Noah.mp3'),
];

class VoiceModelScreen extends StatefulWidget {
  final VoiceModel initialVoice;
  const VoiceModelScreen({Key? key, required this.initialVoice}) : super(key: key);

  @override
  State<VoiceModelScreen> createState() => _VoiceModelScreenState();
}

class _VoiceModelScreenState extends State<VoiceModelScreen> {
  late PageController _pageController;
  late int _currentIndex;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _currentIndex = voiceModels.indexWhere((v) => v.id == widget.initialVoice.id);
    if (_currentIndex == -1) _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
    // Play initial preview
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playPreview(voiceModels[_currentIndex].previewAsset);
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _playPreview(String assetPath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath.replaceFirst('assets/', '')));
    } catch (e) {
      // ignore errors for missing files
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Choose a voice',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: voiceModels.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                  _playPreview(voiceModels[index].previewAsset);
                },
                itemBuilder: (context, index) {
                  final voice = voiceModels[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 220,
                        height: 220,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/image/voice.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        voice.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        voice.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                voiceModels.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.white : Colors.white24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(voiceModels[_currentIndex]);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Done'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 