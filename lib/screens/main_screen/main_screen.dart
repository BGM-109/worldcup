import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worldcup/screens/play_screen/play_screen.dart';
import 'package:worldcup/screens/select_round_screen/select_round_screen.dart';

final topicProvider = StreamProvider(
    (ref) => FirebaseFirestore.instance.collection('topics').snapshots());

final selectedTopicProvider = StateProvider<String>((ref) => '');
final selectedRoundProvider = StateProvider<List<int>>((ref) => []);

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = "/main_screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(topicProvider);
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: topics.when(
                data: (topic) => Body(data: topic),
                error: (e, st) => const Text("error"),
                loading: () => const CircularProgressIndicator())));
  }
}

class Body extends StatelessWidget {
  const Body({Key? key, required this.data}) : super(key: key);
  final QuerySnapshot<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            data.docs.map((e) => ChoiceTopicButton(data: e.data())).toList());
  }
}

class ChoiceTopicButton extends ConsumerWidget {
  const ChoiceTopicButton({Key? key, required this.data}) : super(key: key);
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTopic = ref.watch(selectedTopicProvider.notifier);
    final selectedRound = ref.watch(selectedRoundProvider.notifier);
    return TextButton(
        onPressed: () {
          selectedTopic.state = data['value'];
          print(data['rounds']);
          List<int> list = [...data['rounds']];

          selectedRound.state = [...list];
          GoRouter.of(context).push(PlayScreen.routeName);
        },
        child: Text(data['title']));
  }
}
