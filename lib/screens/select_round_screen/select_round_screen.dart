import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worldcup/screens/main_screen/main_screen.dart';

import '../play_screen/play_screen.dart';

final gameRoundProvider = StateProvider<int>(
    (ref) => 0
);


class SelectRoundScreen extends StatelessWidget {
  const SelectRoundScreen({
    Key? key,
  }) : super(key: key);
  static const String routeName = "/select_round_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ChoiceRoundBox());
  }
}

class ChoiceRoundBox extends ConsumerWidget {
  const ChoiceRoundBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roundProvider = ref.watch(selectedRoundProvider.notifier);
    final gRoundProvider = ref.watch(gameRoundProvider.notifier);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: roundProvider.state.map((int r) => OutlinedButton(
          onPressed: (){
            gRoundProvider.state = r;
            GoRouter.of(context).go(PlayScreen.routeName);
          },
          child: Text("${r}강"),
        )).toList(),
      ),
    );
  }
}
