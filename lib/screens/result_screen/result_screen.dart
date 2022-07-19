import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worldcup/screens/play_screen/play_provider.dart';

class ResultScreen extends ConsumerStatefulWidget {
  static const String routeName = "/result_screen";

  const ResultScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final controller = ConfettiController();
  bool isPlaying = false;

  @override
  void initState() {
    controller.play();
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      controller.stop();
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(resultProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (result != null)
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(result.igmUrl))),
              )
            else
              Container(),
            Center(
                child: ConfettiWidget(
              confettiController: controller,
              shouldLoop: false,
            )),
            ElevatedButton(
                onPressed: () {
                  context.go('/');
                },
                child: Text("처음으로 가기")),
            ElevatedButton(
              onPressed: () {},
              child: Text("공유하기"),
            ),
            Text("댓글영역"),
            Text("결과 랭킹 테이블"),
          ],
        ),
      ),
    );
  }
}
