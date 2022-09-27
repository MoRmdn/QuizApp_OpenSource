import 'package:QuizApp/screens/auth/login_screen.dart';
import 'package:QuizApp/screens/auth/registration.dart';
import 'package:QuizApp/screens/home_page.dart';
import 'package:QuizApp/screens/quiz_screen.dart';
import 'package:QuizApp/screens/result_screen/result_screen.dart';
import 'package:QuizApp/screens/topics.dart';
import 'package:QuizApp/screens/users_home.dart';
import 'package:QuizApp/util/bindings_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Question & Answer',
      theme: ThemeData().copyWith(
        // change the focus border color of the TextField
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: const Color(0xFFF6AF56),
              secondary: const Color(0xff2C3848),
            ),
        // change the focus border color when the errorText is set
        errorColor: Colors.purple,
      ),
      initialBinding: BilndingsApp(),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User userData = snapshot.data as User;
              return userData.uid == '3o24mZeno5Y4UFKXohjFBOnF2JQ2'
                  ? const HomePage()
                  : UserHomeScreen();
            } else {
              return const LoginScreen();
            }
          }),
      getPages: [
        GetPage(
          name: UserHomeScreen.routeName,
          page: () => UserHomeScreen(),
        ),
        GetPage(
          name: QuizScreen.routeName,
          page: () => QuizScreen(),
        ),
        GetPage(name: ResultScreen.routeName, page: () => const ResultScreen()),
        GetPage(
          name: TopicsScreen.routeName,
          page: () => TopicsScreen(),
        ),
        GetPage(
          name: Registration.routeName,
          page: () => const Registration(),
        ),
      ],
    );
  }
}
