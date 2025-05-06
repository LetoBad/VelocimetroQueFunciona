import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:velocimetro/viewmodels/viagem_viewmodel.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar a orientação do dispositivo para retrato
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configurar a cor da barra de status
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ViagemViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Velocímetro & Hodômetro',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.blueGrey.shade900,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey.shade800,
            elevation: 0,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
