import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldcup/round_screen.dart';

final roundProvider = StateProvider<Round>((ref) => Round.none);

enum Round {
  none(0),
  roundOne(16),
  roundTwo(32),
  roundThree(64),
  roundFour(128);

  const Round(this.length);

  final int length;
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: Round.values
              .map((r) => TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RoundScreen()),
                    );
                    ref.read(roundProvider.state).state = r;
                    ref.read(stepProvider.state).state = 0;
                    ref.read(nextRoundProvider.notifier).reset();
                  },
                  child: Text(r.length.toString())))
              .toList(),
        ),
      ),
    );
  }
}
