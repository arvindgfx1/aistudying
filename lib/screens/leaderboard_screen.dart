import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  final List<String> _tabs = ['Today', 'Weekly', 'All Time'];

  // Mock leaderboard data
  final List<Map<String, dynamic>> _top3 = [
    {
      'name': 'Jhon',
      'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
      'score': 180,
      'color': Colors.orange,
    },
    {
      'name': 'Jhon',
      'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
      'score': 160,
      'color': Colors.green,
    },
    {
      'name': 'Jhon',
      'avatar': 'https://randomuser.me/api/portraits/men/45.jpg',
      'score': 120,
      'color': Colors.purple,
    },
  ];

  final List<Map<String, dynamic>> _users = [
    {
      'name': 'FrostPhoenix',
      'avatar': 'https://randomuser.me/api/portraits/men/11.jpg',
      'score': 150,
    },
    {
      'name': 'StealthGamer',
      'avatar': 'https://randomuser.me/api/portraits/women/12.jpg',
      'score': 144,
    },
    {
      'name': 'CyberSorcerer',
      'avatar': 'https://randomuser.me/api/portraits/men/13.jpg',
      'score': 140,
    },
    {
      'name': 'ThunderJester',
      'avatar': 'https://randomuser.me/api/portraits/men/14.jpg',
      'score': 132,
    },
    {
      'name': 'Kevin Lee',
      'avatar': 'https://randomuser.me/api/portraits/men/15.jpg',
      'score': 128,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B61FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Leaderboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              labelColor: const Color(0xFF7B61FF),
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildTop3(),
          const SizedBox(height: 16),
          Expanded(child: _buildLeaderboardList()),
        ],
      ),
    );
  }

  Widget _buildTop3() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTopUser(_top3[1], 2),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            _buildTopUser(_top3[0], 1, isCenter: true),
            Positioned(
              top: 0,
              child: Icon(Icons.emoji_events, color: Colors.orange, size: 36),
            ),
          ],
        ),
        _buildTopUser(_top3[2], 3),
      ],
    );
  }

  Widget _buildTopUser(Map<String, dynamic> user, int rank, {bool isCenter = false}) {
    return Column(
      children: [
        Container(
          width: isCenter ? 80 : 64,
          height: isCenter ? 80 : 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: user['color'] ?? Colors.white,
              width: isCenter ? 4 : 2,
            ),
            boxShadow: [
              if (isCenter)
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: CircleAvatar(
            backgroundImage: NetworkImage(user['avatar']),
            radius: isCenter ? 36 : 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user['name'],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: (user['color'] ?? Colors.white).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            user['score'].toString(),
            style: TextStyle(
              color: user['color'] ?? Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user['avatar']),
              radius: 22,
            ),
            title: Text(
              user['name'],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events, color: Color(0xFFFFB800), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    user['score'].toString(),
                    style: const TextStyle(
                      color: Color(0xFF7B61FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            leadingAndTrailingTextStyle: const TextStyle(color: Colors.white),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            minVerticalPadding: 0,
          ),
        );
      },
    );
  }
} 