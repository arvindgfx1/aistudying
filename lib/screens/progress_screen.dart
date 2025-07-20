import 'package:flutter/material.dart';
import 'leaderboard_screen.dart';

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Progress'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leaderboard Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeaderboardScreen()),
                  );
                },
                icon: const Icon(Icons.emoji_events),
                label: const Text('View Leaderboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B61FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 4,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Weekly Overview Card
            _buildWeeklyOverviewCard(context),
            const SizedBox(height: 24),
            // Subject Progress
            Text(
              'Subject Progress',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildSubjectProgressList(context),
            const SizedBox(height: 24),
            // Recent Activities
            Text(
              'Recent Activities',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildRecentActivitiesList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyOverviewCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade600],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Weekly Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('Study Time', '12h 30m', Icons.access_time),
                ),
                Expanded(
                  child: _buildStatItem('Topics Completed', '8', Icons.check_circle),
                ),
                Expanded(
                  child: _buildStatItem('Quiz Score', '85%', Icons.quiz),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSubjectProgressList(BuildContext context) {
    final subjects = [
      {'name': 'Mathematics', 'progress': 0.75, 'color': Colors.blue},
      {'name': 'Science', 'progress': 0.60, 'color': Colors.green},
      {'name': 'English', 'progress': 0.85, 'color': Colors.orange},
      {'name': 'Computer Science', 'progress': 0.45, 'color': Colors.purple},
    ];

    return Column(
      children: subjects.map((subject) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subject['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${((subject['progress'] as double) * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: subject['color'] as Color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: subject['progress'] as double,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(subject['color'] as Color),
                  minHeight: 8,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentActivitiesList(BuildContext context) {
    final activities = [
      {
        'title': 'Completed Algebra Quiz',
        'subtitle': 'Mathematics • 2 hours ago',
        'icon': Icons.quiz,
        'color': Colors.blue,
      },
      {
        'title': 'Scanned Physics Chapter',
        'subtitle': 'Science • 4 hours ago',
        'icon': Icons.camera_alt,
        'color': Colors.green,
      },
      {
        'title': 'Asked AI about Literature',
        'subtitle': 'English • 6 hours ago',
        'icon': Icons.chat_bubble,
        'color': Colors.orange,
      },
      {
        'title': 'Completed Programming Exercise',
        'subtitle': 'Computer Science • 1 day ago',
        'icon': Icons.code,
        'color': Colors.purple,
      },
    ];

    return Column(
      children: activities.map((activity) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: (activity['color'] as Color).withOpacity(0.2),
              child: Icon(
                activity['icon'] as IconData,
                color: activity['color'] as Color,
              ),
            ),
            title: Text(
              activity['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(activity['subtitle'] as String),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Activity details coming soon!'),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
} 