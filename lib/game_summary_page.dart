import 'package:flutter/material.dart';
import 'models.dart';
import 'game_setting_page.dart';

class GameSummaryPage extends StatelessWidget {
  final Game game;
  final int t1Score;
  final int t2Score;
  final String winner;

  const GameSummaryPage({Key? key, required this.game, required this.t1Score, required this.t2Score, required this.winner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Oyun Özeti'), automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Kazanan', style: TextStyle(fontSize: 24, color: Colors.white)),
            SizedBox(height: 15),
            Text(winner, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.yellow)),
            SizedBox(height: 15),
            Text('${game.team1Name}: $t1Score', style: TextStyle(fontSize: 20, color: Colors.white)),
            SizedBox(height: 10),
            Text('${game.team2Name}: $t2Score', style: TextStyle(fontSize: 20, color: Colors.white)),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GameSettingPage())),
              child: Text('Rövanş (Yeni Oyun Ayarları)'),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: Text('Ana Sayfaya Dön', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}