import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worldcup/screens/play_screen/play_screen.dart';
import 'package:worldcup/screens/result_screen/result_screen.dart';

final crossFadeProvider = StateProvider.autoDispose<bool>((ref) => false);


class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = "/main_screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCrossFade = ref.watch(crossFadeProvider.state);
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  "프로틴월드컵",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ))),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedCrossFade(
                      firstChild: FirstChild(isCrossFade: isCrossFade),
                      secondChild: SecondChild(isCrossFade: isCrossFade),
                      duration: const Duration(milliseconds: 1000),
                      crossFadeState: isCrossFade.state == false
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                    ),
                  ],
                )),
          ],
        ));
  }
}

class SecondChild extends StatelessWidget {
  const SecondChild({
    Key? key,
    required this.isCrossFade,
  }) : super(key: key);

  final StateController<bool> isCrossFade;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              context.go("${PlayScreen.routeName}?round=16");
            },
            child: const Text("16강")),
        ElevatedButton(
            onPressed: () {
              context.go("${PlayScreen.routeName}?round=32");
            },
            child: const Text("32강")),
        ElevatedButton(onPressed: () {}, child: const Text("64강")),
        ElevatedButton(
            onPressed: () {
              isCrossFade.state = false;
            },
            child: const Text("뒤로가기")),
      ],
    );
  }
}

class FirstChild extends StatelessWidget {
  const FirstChild({
    Key? key,
    required this.isCrossFade,
  }) : super(key: key);

  final StateController<bool> isCrossFade;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              isCrossFade.state = true;
            },
            child: const Text("시작하기")),
        ElevatedButton(
            onPressed: () {
              context.go(ResultScreen.routeName);
            },
            child: const Text("순위보기")),
      ],
    );
  }
}
