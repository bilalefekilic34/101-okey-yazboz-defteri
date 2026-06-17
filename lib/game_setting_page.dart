import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'scoreboard_page.dart';

class GameSettingPage extends StatefulWidget {
  @override
  _GameSettingPageState createState() => _GameSettingPageState();
}

class _GameSettingPageState extends State<GameSettingPage> {
  final _t1Controller = TextEditingController();
  final _t2Controller = TextEditingController();
  final _roundsController = TextEditingController();

  void _startGame() async {
    if (_t1Controller.text.isEmpty || _t2Controller.text.isEmpty || _roundsController.text.isEmpty) return;

    final newGame = Game(
      team1Name: _t1Controller.text,
      team2Name: _t2Controller.text,
      totalRounds: int.parse(_roundsController.text),
      gameDate: DateTime.now().toIso8601String(),
    );

    final gameId = await DatabaseHelper.instance.createNewGame(newGame);

    // ID atandıktan sonra tam nesneyi sayfaya gönderiyoruz
    final createdGame = Game(
      id: gameId,
      team1Name: newGame.team1Name,
      team2Name: newGame.team2Name,
      totalRounds: newGame.totalRounds,
      gameDate: newGame.gameDate,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ScoreboardPage(game: createdGame)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Oyun Ayarları')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _t1Controller, decoration: InputDecoration(labelText: 'Takım 1 Adı')),
            TextField(controller: _t2Controller, decoration: InputDecoration(labelText: 'Takım 2 Adı')),
            TextField(controller: _roundsController, decoration: InputDecoration(labelText: 'Kaç El Sürecek?'), keyboardType: TextInputType.number),
            SizedBox(height: 30),
            ElevatedButton(onPressed: _startGame, child: Text('Oyunu Başlat')),
          ],
        ),
      ),
    );
  }
}