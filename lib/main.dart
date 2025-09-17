import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skornament/screens/auth/login_screen.dart';
import 'package:skornament/screens/onboarding_screen/onboarding_screen.dart';



void main() {
   WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SK Ornament',
      home: LoginScreen(),
    );
  }
}

