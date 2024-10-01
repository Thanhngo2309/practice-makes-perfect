import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/application-service/SharedPrefs.dart';
import 'package:myapp/model/Subject.dart';
import 'package:myapp/widgets/AddExam.dart';
import 'package:myapp/widgets/ChatScreen.dart';
import 'package:myapp/widgets/ChatWidget.dart';
import 'package:myapp/widgets/ExamScreenWidget.dart';
import 'package:myapp/widgets/HomeWidget.dart';
import 'package:myapp/widgets/LoginWidget.dart';
import 'package:myapp/widgets/ProfileWidget.dart';
import 'package:myapp/widgets/ResultWidget.dart';
import './widgets/ResetPasswordScreen.dart';
import './widgets/RegisterWidget.dart';
import './routes/UserProtectRoute.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPrefs.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == ExamScreenWidget.routeName) {
          final subject = settings.arguments as Subject;
          return MaterialPageRoute(
            builder: (context) => ExamScreenWidget(
              subject: subject,
            ),
          );
        }
        return null;
      },
      initialRoute: '/add-exam',
      routes: {
        '/chat': (context) => ChatSreen(),
        '/signin': (context) => const LoginPage(),
        '/': (context) => UserProtectRoute(child: HomeScreen()),
        '/signup': (context) => const SignInPage2(),
        '/reset-password': (context) => const ResetPasswordPage(),
        '/add-exam': (context) => AddExam(),
        '/profile': (context) => ProfileWidget()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
