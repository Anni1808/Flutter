//main
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

void main() async {
  // Ensure Flutter is initialized before accessing platform-specific features
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImmoDrops',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pinkAccent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => SplashScreen(),
        '/login': (_) => LoginScreen(),
        '/signup': (_) => SignupScreen(),
        '/home': (_) => HomeScreen(),
      },
      // For profile screen, we need to pass email parameter so we'll handle it in onGenerateRoute
      onGenerateRoute: (settings) {
        if (settings.name == '/profile') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ProfileScreen(email: args),
          );
        }
        return null;
      },
    );
  }
}
