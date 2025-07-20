import 'package:flutter/material.dart';

class SubjectsScreen extends StatelessWidget {
  final List<Subject> subjects = [
    Subject(
      name: 'Mathematics',
      icon: Icons.calculate,
      color: Colors.blue,
      description: 'Algebra, Geometry, Calculus',
      topics: ['Algebra', 'Geometry', 'Calculus', 'Statistics'],
    ),
    Subject(
      name: 'Science',
      icon: Icons.science,
      color: Colors.green,
      description: 'Physics, Chemistry, Biology',
      topics: ['Physics', 'Chemistry', 'Biology', 'Environmental Science'],
    ),
    Subject(
      name: 'English',
      icon: Icons.menu_book,
      color: Colors.orange,
      description: 'Literature, Grammar, Writing',
      topics: ['Literature', 'Grammar', 'Writing', 'Vocabulary'],
    ),
    Subject(
      name: 'Computer Science',
      icon: Icons.computer,
      color: Colors.purple,
      description: 'Programming, Algorithms, Data Structures',
      topics: ['Programming', 'Algorithms', 'Data Structures', 'Web Development'],
    ),
    Subject(
      name: 'History',
      icon: Icons.history,
      color: Colors.brown,
      description: 'World History, Indian History',
      topics: ['Ancient History', 'Modern History', 'Indian History', 'World Wars'],
    ),
    Subject(
      name: 'Geography',
      icon: Icons.public,
      color: Colors.teal,
      description: 'Physical Geography, Human Geography',
      topics: ['Physical Geography', 'Human Geography', 'Maps', 'Climate'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Subjects'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a Subject',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore topics and learn at your own pace',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return _buildSubjectCard(context, subjects[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Subject subject) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showSubjectDetails(context, subject),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                subject.color.withOpacity(0.1),
                subject.color.withOpacity(0.2),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                subject.icon,
                size: 48,
                color: subject.color,
              ),
              const SizedBox(height: 16),
              Text(
                subject.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: subject.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subject.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: subject.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${subject.topics.length} Topics',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: subject.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubjectDetails(BuildContext context, Subject subject) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    subject.icon,
                    size: 32,
                    color: subject.color,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      subject.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: subject.color,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                subject.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Topics',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: subject.topics.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: subject.color.withOpacity(0.2),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: subject.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(subject.topics[index]),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${subject.topics[index]} content coming soon!'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Subject {
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  final List<String> topics;

  Subject({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    required this.topics,
  });
} 