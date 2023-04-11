import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auction_app/firebase_options.dart';
import 'package:flutter_auction_app/view/screens/add_employee.dart';
import 'package:flutter_auction_app/view/screens/home_screen.dart';
import 'package:flutter_auction_app/view/screens/login_screen.dart';
import 'package:flutter_auction_app/view/screens/my_product_screen.dart';
import 'package:flutter_auction_app/view/screens/splash_screen.dart';
import 'package:flutter_auction_app/view/screens/user_messanger.dart';
import 'package:flutter_auction_app/view/widgets/post_item_bottomsheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'view/screens/all_user_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        PostItemScreen.id: (context) => const PostItemScreen(),
        MyProductScreen.id: (context) => const MyProductScreen(),
        AllUserScreen.id: (context) => const AllUserScreen(),
        MessengerUserScreen.id: (context) => const MessengerUserScreen(),
        AddEmployeeScreen.id: (context) => AddEmployeeScreen(),
      },
    );
  }
}
