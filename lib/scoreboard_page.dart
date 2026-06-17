import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'game_summary_page.dart';

class ScoreboardPage extends StatefulWidget {
  final Game game;
  const ScoreboardPage({Key? key, required this.game}) : super(key: key);

  @override
  _ScoreboardPageState createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  List<RoundScore> _rounds = [];
  int _currentRound = 1;
  int _t1Total = 0;
  int _t2Total = 0;

  int _currentT1Penalty = 0;
  int _currentT2Penalty = 0;

  final _t1ScoreController = TextEditingController();
  final _t2ScoreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  void _loadScores() async {
    final scores = await DatabaseHelper.instance.getRoundScoresForGame(widget.game.id!);
    int t1Sum = 0;
    int t2Sum = 0;
    for (var s in scores) {
      t1Sum += s.team1Score + s.team1Penalty;
      t2Sum += s.team2Score + s.team2Penalty;
    }

    setState(() {
      _rounds = scores;
      _currentRound = scores.length + 1;
      _t1Total = t1Sum;
      _t2Total = t2Sum;
    });

    if (_currentRound > widget.game.totalRounds) {
      _finishGameAndNavigate();
    }
  }

  void _finishGameAndNavigate() async {
    String winner = _t1Total < _t2Total ? widget.game.team1Name : widget.game.team2Name;
    if (_t1Total == _t2Total) winner = "Berabere";

    await DatabaseHelper.instance.finishGame(widget.game.id!, winner);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GameSummaryPage(game: widget.game, t1Score: _t1Total, t2Score: _t2Total, winner: winner)),
    );
  }

  void _saveRound() async {
    final t1S = int.tryParse(_t1ScoreController.text) ?? 0;
    final t2S = int.tryParse(_t2ScoreController.text) ?? 0;

    final score = RoundScore(
      gameId: widget.game.id!,
      roundNumber: _currentRound,
      team1Score: t1S,
      team2Score: t2S,
      team1Penalty: _currentT1Penalty,
      team2Penalty: _currentT2Penalty,
    );

    await DatabaseHelper.instance.saveRoundScore(score);

    _t1ScoreController.clear();
    _t2ScoreController.clear();
    _currentT1Penalty = 0;
    _currentT2Penalty = 0;

    _loadScores();
  }

  void _showPenaltyModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ceza Ekle (Anlık El İçin)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              ListTile(
                title: Text('İşlek / Okey / Hatalı El (+101)', style: TextStyle(color: Colors.black)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(onPressed: () { setState(() { _currentT1Penalty += 101; }); Navigator.pop(context); }, child: Text(widget.game.team1Name)),
                    TextButton(onPressed: () { setState(() { _currentT2Penalty += 101; }); Navigator.pop(context); }, child: Text(widget.game.team2Name)),
                  ],
                ),
              ),
              ListTile(
                title: Text('Taş Çaldırma (Değer x 10)', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  _showStolenTileDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStolenTileDialog() {
    final _tileController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Çalınan Taş Değeri'),
          content: TextField(controller: _tileController, keyboardType: TextInputType.number),
          actions: [
            TextButton(
              onPressed: () {
                final val = int.tryParse(_tileController.text) ?? 0;
                setState(() { _currentT1Penalty += (val * 10); });
                Navigator.pop(context);
              },
              child: Text(widget.game.team1Name),
            ),
            TextButton(
              onPressed: () {
                final val = int.tryParse(_tileController.text) ?? 0;
                setState(() { _currentT2Penalty += (val * 10); });
                Navigator.pop(context);
              },
              child: Text(widget.game.team2Name),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka planı koyu yeşil (Okey masası rengi) olarak sabitliyoruz
      backgroundColor: const Color(0xFF387024),
      appBar: AppBar(
        title: Text('Canlı Skor - El $_currentRound / ${widget.game.totalRounds}', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black, // Ekrandaki gibi siyah AppBar
        iconTheme: IconThemeData(color: Colors.white), // Geri tuşunu beyaz yapar
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. Başlık ve Toplam Skorlar Alanı
          IntrinsicHeight( // VerticalDivider'ın yüksekliğini sınırlandırmak için gerekli
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(widget.game.team1Name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        SizedBox(height: 4),
                        Text('Toplam: $_t1Total', style: TextStyle(fontSize: 16, color: Colors.white70)),
                      ],
                    ),
                  ),
                  // Dikey Ayırıcı Çizgi
                  VerticalDivider(color: Colors.white, thickness: 1, width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        Text(widget.game.team2Name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        SizedBox(height: 4),
                        Text('Toplam: $_t2Total', style: TextStyle(fontSize: 16, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.white, thickness: 1, height: 1), // Yatay ana çizgi

          // 2. Geçmiş Eller (Yazboz Kağıdı Alanı)
          Expanded(
            child: ListView.builder(
              itemCount: _rounds.length,
              itemBuilder: (context, index) {
                final r = _rounds[index];
                return Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          // Sol Taraftaki El Numarası Belirteci
                          Container(
                            width: 40,
                            alignment: Alignment.center,
                            child: Text('${r.roundNumber}.', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                          ),
                          // Takım 1 Puanı
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Center(
                                child: Text(
                                    '${r.team1Score} ${r.team1Penalty > 0 ? "(+${r.team1Penalty})" : ""}',
                                    style: TextStyle(color: Colors.white, fontSize: 16)
                                ),
                              ),
                            ),
                          ),
                          // Orta Çizgi (Her satırda devam eder)
                          VerticalDivider(color: Colors.white54, thickness: 1, width: 1),
                          // Takım 2 Puanı
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Center(
                                child: Text(
                                    '${r.team2Score} ${r.team2Penalty > 0 ? "(+${r.team2Penalty})" : ""}',
                                    style: TextStyle(color: Colors.white, fontSize: 16)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.white24, height: 1, thickness: 1), // Her elin altındaki hafif silik çizgi
                  ],
                );
              },
            ),
          ),

          // 3. Yeni El Puan Giriş Alanı
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: _t1ScoreController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '${widget.game.team1Name} Puanı',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    )
                ),
                SizedBox(width: 10),
                Expanded(
                    child: TextField(
                      controller: _t2ScoreController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '${widget.game.team2Name} Puanı',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    )
                ),
              ],
            ),
          ),

          if (_currentT1Penalty > 0 || _currentT2Penalty > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                  'Bekleyen Cezalar -> ${widget.game.team1Name}: +$_currentT1Penalty | ${widget.game.team2Name}: +$_currentT2Penalty',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)
              ),
            ),

          // 4. Alt Butonlar
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: _showPenaltyModal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white, // Buton içi yazı rengi
                    ),
                    child: Text('Cezalar')
                ),
                ElevatedButton(
                    onPressed: _saveRound,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black, // Ekrandaki buton gibi beyaz arkaplan - siyah yazı
                    ),
                    child: Text('Eli Kaydet')
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}