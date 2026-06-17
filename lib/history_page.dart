import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Geçmiş Oyunlar')),
      body: FutureBuilder<List<Game>>(
        future: DatabaseHelper.instance.getGameHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          if (snapshot.data!.isEmpty) return Center(child: Text('Henüz bitmiş oyun yok.'));

          final games = snapshot.data!;
          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              final date = DateTime.parse(game.gameDate);
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text('${game.team1Name} vs ${game.team2Name}'),
                  subtitle: Text('${date.day}/${date.month}/${date.year} - Hedef: ${game.totalRounds} El'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Kazanan', style: TextStyle(fontSize: 12)),
                      Text(game.winnerTeam ?? 'Bilinmiyor', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}