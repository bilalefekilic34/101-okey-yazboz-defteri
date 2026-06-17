import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  // Flutter binding'lerini başlatıyoruz, SQLite veya diğer asenkron işlemler
  // uygulama başlamadan önce çalışacaksa bu satır gereklidir.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Okey101App());
}

class Okey101App extends StatelessWidget {
  const Okey101App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '101 Okey Yazboz',
      // Sağ üst köşedeki 'DEBUG' etiketini gizler
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.lightGreen[900],
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white, // AppBar yazı ve ikon rengi
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      // Uygulamanın açılış sayfası
      home: HomePage(),
    );
  }
}