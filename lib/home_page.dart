import 'package:flutter/material.dart';
import 'game_setting_page.dart';
import 'history_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('101 Okey Yazboz')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/logo.jpg',
            width: 150,
            height: 150,
          ),

            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GameSettingPage())),
              child: Text('Yeni Oyun Oluştur'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryPage())),
              child: Text('Geçmiş Oyunları Görüntüle'),
            ),
          ],
        ),
      ),
    );
  }
}