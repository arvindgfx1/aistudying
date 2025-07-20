import 'package:flutter/material.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int _selectedOption = -1;
  bool _answered = false;
  bool _showHint = false;
  int _timer = 20;
  Timer? _countdown;

  // Mock quiz data
  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'text',
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Mars', 'Venus', 'Jupiter', 'Saturn'],
      'answer': 0,
      'hint': 'It is named after the Roman god of war.',
      'subject': 'Science Quiz',
    },
    {
      'type': 'text',
      'question': 'What is the most popular sport throughout the world?',
      'options': ['Soccer', 'Basketball', 'Cricket', 'Badminton'],
      'answer': 0,
      'hint': 'It is also called football in many countries.',
      'subject': 'Sports Quiz',
    },
    {
      'type': 'image',
      'question': 'This is a book?\nTrue or False?',
      'image': 'https://images.unsplash.com/photo-1512820790803-83ca734da794',
      'options': ['True', 'False'],
      'answer': 0,
      'hint': 'Look at the object carefully.',
      'subject': 'Picture Quiz',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = 20;
    _countdown?.cancel();
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timer > 0) {
          _timer--;
        } else {
          _countdown?.cancel();
          _answered = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _countdown?.cancel();
    super.dispose();
  }

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
      _countdown?.cancel();
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestion++;
      _selectedOption = -1;
      _answered = false;
      _showHint = false;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentQuestion];
    final total = _questions.length;
    final isLast = _currentQuestion == total - 1;
    return Scaffold(
      backgroundColor: const Color(0xFF7B61FF),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar & Counter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '0${_currentQuestion + 1} of 0$total',
                      style: const TextStyle(
                        color: Color(0xFF7B61FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentQuestion + 1) / total,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '0${_currentQuestion + 1} of 0$total',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Timer
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      value: _timer / 20,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                      strokeWidth: 6,
                    ),
                  ),
                  Text(
                    '$_timer',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            // Question Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => setState(() => _showHint = !_showHint),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.lightbulb, color: Colors.orange, size: 18),
                                    SizedBox(width: 4),
                                    Text('Hint', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              'Question ${(_currentQuestion + 1).toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Color(0xFF7B61FF),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          q['subject'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_showHint)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, color: Colors.orange, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    q['hint'],
                                    style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (q['type'] == 'image')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                q['image'],
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        Text(
                          q['question'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ...List.generate(q['options'].length, (i) {
                          final isCorrect = _answered && i == q['answer'];
                          final isWrong = _answered && i == _selectedOption && i != q['answer'];
                          return GestureDetector(
                            onTap: () => _selectOption(i),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? Colors.green.withOpacity(0.15)
                                    : isWrong
                                        ? Colors.red.withOpacity(0.08)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isCorrect
                                      ? Colors.green
                                      : isWrong
                                          ? Colors.red
                                          : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      q['options'][i],
                                      style: TextStyle(
                                        color: isCorrect
                                            ? Colors.green
                                            : isWrong
                                                ? Colors.red
                                                : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  if (_answered && i == q['answer'])
                                    const Icon(Icons.check_circle, color: Colors.green, size: 22),
                                  if (_answered && i == _selectedOption && i != q['answer'])
                                    const Icon(Icons.cancel, color: Colors.red, size: 22),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _answered
                      ? (isLast
                          ? () => Navigator.pop(context)
                          : _nextQuestion)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Text(isLast ? 'Finish' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 