import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worldcup/firebase_options.dart';
import 'package:worldcup/home_screen.dart';
import 'package:worldcup/screens/main_screen/main_screen.dart';
import 'package:worldcup/screens/play_screen/play_screen.dart';
import 'package:worldcup/screens/select_round_screen/select_round_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      initialLocation: MainScreen.routeName,
      routes: [
        GoRoute(
          path: MainScreen.routeName,
          builder: (context, state) => const MainScreen(),
        ),
        GoRoute(
          path: SelectRoundScreen.routeName,
          builder: (context, state) => const SelectRoundScreen(),
        ),
        GoRoute(
          path: PlayScreen.routeName,
          builder: (context, state) => const PlayScreen(),
        ),
      ],
    );
    return MaterialApp.router(
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,

      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),

    );
  }
}
