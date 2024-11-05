import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    print('Initializing Firebase...'); // Debug log
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully'); // Debug log
    runApp(const MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e'); // Debug log
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Demo App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: WillPopScope(
        onWillPop: () async {
          final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
          
          if (currentRoute == '/login' || currentRoute == '/home' || currentRoute == '/splash') {
            await SystemNavigator.pop();
            return false;
          }
          return true;
        },
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Show splash screen while checking auth state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            
            // Return splash screen initially, it will handle navigation
            return const SplashScreen();
          },
        ),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}