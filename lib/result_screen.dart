import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final winnerProvider = StateProvider<int>((ref) => 0);

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("우승"),
          ResultText(),
        ],
      )),
    );
  }
}

class ResultText extends ConsumerWidget {
  const ResultText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final winner = ref.watch(winnerProvider);
    return Text(winner.toString());
  }
}
