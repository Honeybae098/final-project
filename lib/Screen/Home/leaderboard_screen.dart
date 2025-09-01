import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  int _selectedTab = 0;

  final List<LeaderboardPlayer> _leaderboardData = const [
    LeaderboardPlayer(rank: 1, name: 'Calzoni', score: 12400, avatar: 'assets/avatar1.png'),
    LeaderboardPlayer(rank: 2, name: 'Donin', score: 11200, avatar: 'assets/avatar2.png'),
    LeaderboardPlayer(rank: 3, name: 'Baptista', score: 10500, avatar: 'assets/avatar3.png'),
    LeaderboardPlayer(rank: 4, name: 'Brandon Siphron', score: 9888, avatar: 'assets/avatar4.png'),
    LeaderboardPlayer(rank: 5, name: 'Roger Donin', score: 9888, avatar: 'assets/avatar5.png'),
    LeaderboardPlayer(rank: 6, name: 'Allison Vaccaro', score: 9888, avatar: 'assets/avatar6.png'),
  ];

  static const Color _backgroundColor = Color(0xFF1B1B1B);
  static const Color _cardColor = Color(0xFF2A2A2A);
  static const Color _primaryColor = Colors.deepPurpleAccent;
  static const Color _textPrimary = Colors.white;
  static const Color _textSecondary = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _buildAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: _backgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTabSelector(),
                const SizedBox(height: 20),
                _buildPlayerStatus(),
                const SizedBox(height: 20),
                _buildPodium(),
                const SizedBox(height: 20),
                Expanded(child: _buildLeaderboardList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: _backgroundColor,
      foregroundColor: _textPrimary,
      title: Text(
        'Leaderboard',
        style: GoogleFonts.kantumruyPro(
          fontWeight: FontWeight.bold,
          color: _textPrimary,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildTab('Weekly', 0),
          _buildTab('All Time', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final bool isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.kantumruyPro(
              color: isSelected ? _textPrimary : _textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.trending_up, color: _primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '#4  You are doing better than 60% of other players!',
              style: GoogleFonts.kantumruyPro(color: _textPrimary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium() {
    if (_leaderboardData.length < 3) return const SizedBox.shrink();

    final first = _leaderboardData[0];
    final second = _leaderboardData[1];
    final third = _leaderboardData[2];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildPodiumPlayer(second, Colors.grey[400]!, 100),
        _buildPodiumPlayer(first, Colors.amber, 140),
        _buildPodiumPlayer(third, Colors.brown[300]!, 100),
      ],
    );
  }

  Widget _buildPodiumPlayer(LeaderboardPlayer player, Color podiumColor, double height) {
    return Column(
      children: [
        if (player.rank == 1)
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Icon(Icons.emoji_events, color: Colors.amber, size: 24),
          ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: podiumColor, width: 3),
          ),
          child: CircleAvatar(
            backgroundImage: AssetImage(player.avatar),
            radius: 30,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            player.name,
            style: GoogleFonts.kantumruyPro(
              color: _textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${player.score} pts',
          style: GoogleFonts.kantumruyPro(color: _textSecondary, fontSize: 10),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          width: 60,
          decoration: BoxDecoration(
            color: podiumColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${player.rank}',
            style: GoogleFonts.kantumruyPro(
              color: _textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    final remainingPlayers = _leaderboardData.skip(3).toList();

    if (remainingPlayers.isEmpty) {
      return const Center(
        child: Text('No more players to show', style: TextStyle(color: _textSecondary)),
      );
    }

    return ListView.separated(
      itemCount: remainingPlayers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final player = remainingPlayers[index];
        return _buildLeaderboardItem(player);
      },
    );
  }

  Widget _buildLeaderboardItem(LeaderboardPlayer player) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${player.rank}',
              style: GoogleFonts.kantumruyPro(
                color: _primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundImage: AssetImage(player.avatar),
            radius: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              player.name,
              style: GoogleFonts.kantumruyPro(
                color: _textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${player.score} pts',
            style: GoogleFonts.kantumruyPro(
              color: _textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Model class
class LeaderboardPlayer {
  final int rank;
  final String name;
  final int score;
  final String avatar;

  const LeaderboardPlayer({
    required this.rank,
    required this.name,
    required this.score,
    required this.avatar,
  });
}