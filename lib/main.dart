import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pickandgo/provider/google_sign_in.dart';
import 'package:pickandgo/screens/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart' as u;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (u.Platform.operatingSystem == "android" ||
      u.Platform.operatingSystem == "ios") {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      // For Firebase JS SDK v7.20.0 and later, measurementId is optional
      options: const FirebaseOptions(
        apiKey: "AIzaSyBW5JLcglzLsTeJGhJW7ZKYZb8VefvPbtE",
        projectId: "pickandgo-556e9",
        storageBucket: "pickandgo-556e9.appspot.com",
        messagingSenderId: "279679913687",
        appId: "1:279679913687:web:7006c8fc59241566d36a92",
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LoginPage(),
        ),
      );
}
