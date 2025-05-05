import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:velocimetro/viewmodels/viagem_viewmodel.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.deepPurple,
      statusBarIconBrightness: Brightness.light,
    ),
  );

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
          primarySwatch: Colors.indigo,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black87,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.deepPurple,
            elevation: 4,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
