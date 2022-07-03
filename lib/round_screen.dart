import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldcup/result_screen.dart';
import 'home_screen.dart';
import 'dart:math';

final stepProvider = StateProvider<int>((ref) => 0);

final repositoryProvider = StateProvider<List<int>>((ref) {
  final rp = ref.watch(roundProvider);
  int leng = rp.length;
  return List.generate(leng, (index) => index + 1);
});

final currentRoundProvider =
    StateNotifierProvider<CurrentRound, List<int>>((ref) {
  final rp = ref.watch(roundProvider);
  int leng = rp.length;
  return CurrentRound(len: leng);
});

final playersProvider = StateProvider<List<int>>((ref) {
  final rp = ref.watch(currentRoundProvider);
  if (rp.length > 2) {
    var list = rp;
    return [list[0], list[1]];
  } else if (rp.length == 2) {
    return [rp[0], rp[1]];
  }
  return [0, 0];
});

class CurrentRound extends StateNotifier<List<int>> {
  final int len;

  CurrentRound({required this.len})
      : super(List.generate(len, (index) => index + 1)..shuffle());

  void roundChange() {}

  void getList(List<int> preRound) {
    state = [...preRound];
  }

  void goToNext(List<int> p) {
    if (state.length == 2) {
      state = [];
    } else {
      state = [
        for (int i in state)
          if (!p.contains(i)) i,
      ];
    }
  }
}

final nextRoundProvider =
    StateNotifierProvider<NextRound, List<int>>((ref) => NextRound());

class NextRound extends StateNotifier<List<int>> {
  NextRound() : super([]);

  void addPlayer(int n) {
    state = [...state, n];
  }

  void reset() {
    state.clear();
  }
}

class RoundScreen extends ConsumerWidget {
  const RoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<List<int>>(currentRoundProvider,
        (List<int>? previousRound, List<int> newRound) {
      if (newRound.isEmpty) {
        print('Start New Round');
        ref.read(stepProvider.state).state++;
        List<int> nextPlayers = ref.watch(nextRoundProvider);
        ref.read(currentRoundProvider.notifier).getList(nextPlayers);
        ref.read(nextRoundProvider.notifier).reset();
      }
    });
    ref.listen<int>(stepProvider, (int? preStep, newStep) {
      var n = ref.watch(roundProvider);
      final current = ref.watch(currentRoundProvider);
      if (pow(2, newStep) == n.length) {
        int winner = current.first;
        print("우승은 ${winner}");
      }
    });

    // use ref to listen to a provider
    final step = ref.watch(stepProvider);
    final round = ref.watch(roundProvider);
    final players = ref.watch(playersProvider);
    final next = ref.watch(nextRoundProvider);
    final current = ref.watch(currentRoundProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${next.length * 2} / ${round.length ~/ pow(2, step)}"),
            Text('$current'),
            Text(next.toString()),
            Text(step.toString()),
            Row(
              children: players
                  .map((p) => InkWell(
                        onTap: () {
                          if (round.length ~/ pow(2, step) == 2) {
                            ref.read(winnerProvider.state).state = p;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ResultScreen()));
                          } else if (next.length * 2 < round.length) {
                            ref.read(nextRoundProvider.notifier).addPlayer(p);
                            ref
                                .read(currentRoundProvider.notifier)
                                .goToNext(players);
                          }
                        },
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: Text(p.toString()),
                          ),
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
