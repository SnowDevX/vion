import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:grandustionapp/generated/l10n.dart';
import 'package:grandustionapp/screens/account_page.dart';
import 'package:grandustionapp/screens/charging_stations_page.dart';
import 'package:grandustionapp/screens/home_page.dart';
import 'package:grandustionapp/auth/login_page.dart';
import 'package:grandustionapp/auth/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grandustionapp/auth/register_page.dart';
import 'package:grandustionapp/auth/reset_password_page.dart';
import 'package:grandustionapp/providers/language_provider.dart';
import 'package:grandustionapp/screens/rewards_page.dart';
import 'package:grandustionapp/screens/goal_setup_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider( 
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _removeSplashScreen();
  }
  
  Future<void> _removeSplashScreen() async {
    await Future.delayed(const Duration(milliseconds: 100));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: languageProvider.locale,
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const AuthGate(),
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/reset': (context) => const ResetPasswordPage(),
            '/home': (context) => const HomePage(),
            '/goal-setup': (context) => const GoalSetupPage(),
            '/account': (context) => const AccountPage(),
            '/charging-stations': (context) => const ChargingStationsPage(),
            '/rewards': (context) => const RewardsPage(),
          },
        );
      },
    );
  }
}