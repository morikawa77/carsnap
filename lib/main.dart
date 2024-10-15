import 'package:carsnap/history.dart';
import 'package:carsnap/view_car_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'login.page.dart';
import 'register.page.dart';
import 'home.page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa o pacote correto do Firebase Core

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase antes de iniciar o app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa a API Gemini com a chave fornecida
  // A chave da API é usada para autenticar a comunicação com o serviço Gemini
  Gemini.init(apiKey: 'AIzaSyAbowPdk6QfiPWCPmrTlJkcxTiEZGkHUNw');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => HomePage(),
          '/view': (context) => ViewCarPage(),
          '/history': (context) => HistoryPage(),
        },
      ),
    );
  }
}
