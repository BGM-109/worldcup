import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worldcup/constant/colors.dart';
import 'package:worldcup/firebase_options.dart';
import 'package:worldcup/screens/main_screen/main_screen.dart';
import 'package:worldcup/screens/play_screen/play_screen.dart';
import 'package:worldcup/screens/result_screen/result_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: const Color(0xffc3ed64),
            primarySwatch: CombatStyle.primaryColor,
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                )),
      );

  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const MainScreen(),
          routes: [

          ]),
      GoRoute(
          path: PlayScreen.routeName,
          builder: (context, state) {
            final query = state.queryParams['round']; // may be null
            return PlayScreen(query: query);
          }),
      GoRoute(
        path: ResultScreen.routeName,
        builder: (context, state) => const ResultScreen(),
      ),
    ],
  );
}
