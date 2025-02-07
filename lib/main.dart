import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:spms/pages/admin/admin_home_page.dart';
import 'package:spms/pages/app/splash_screen/splash_screen.dart';
import 'package:spms/pages/auth/Login_Page.dart';
import 'package:spms/pages/auth/sign_up_page.dart';
import 'package:spms/pages/captains/captainsHome.dart';
//import 'package:spms/pages/captains/radar.dart';
import 'package:spms/pages/home_page/home_page.dart';
import 'package:spms/stripe/const.dart';

void main() async {
   // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _setup();
  runApp(const MyApp());
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter firebase',
      routes: {
        '/': (context) => const SplashScreen(
          child: LoginPage(),
        ),
        '/logIn': (context) =>const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/admin': (context) => const AdminHomePage(),
        '/captain':(context)=> CaptainApp(),
      // },
      // theme: ThemeData(
        
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      // home: SplashScreen(
      //   child: LoginPage(),
      // ),
      }
      );
  }
}