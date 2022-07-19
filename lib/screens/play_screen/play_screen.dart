import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worldcup/repository/firestore_repository.dart';
import 'package:worldcup/screens/play_screen/play_provider.dart';
import 'package:worldcup/screens/result_screen/result_screen.dart';

class PlayScreen extends ConsumerWidget {
  const PlayScreen({Key? key, required this.query}) : super(key: key);
  final String? query;
  static const String routeName = "/play_screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final round = int.parse(query!);
    final itemsAsync = ref.watch(itemsProvider(round));
    final itemsRead = ref.read(itemsProvider(round).notifier);
    final result = ref.watch(resultProvider.state);

    return Scaffold(
        backgroundColor: Colors.black,
        body: itemsAsync.when(
            data: (data) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "프로틴 월드컵 ${(itemsRead.index * itemsRead.page).toString()} / ${itemsRead.items.length}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Stack(alignment: Alignment.center, children: [
                    Row(children: [
                      ...data
                          .map((p) => Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    if (itemsRead.items.length == 2) {
                                      result.state = p;
                                      GoRouter.of(context)
                                          .push(ResultScreen.routeName);
                                    } else {
                                      ref
                                          .read(itemsProvider(round).notifier)
                                          .selectData(p);
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width / 2,
                                        height: width / 2,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  p.igmUrl,
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ]),
                  ]),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              data[0].title,
                            ),
                            Text(
                              data[0].description,
                            ),
                            Text(data[0].price.toString()),
                            Text(data[0].serving.toString()),
                            Text(data[0].proteins.toString()),
                            Text("단백질성분"),
                            Text("맛")
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              "이름",
                            ),
                            Text("특징"),
                            Text("정가"),
                            Text("용량"),
                            Text("스쿱당 단백질"),
                            Text("단백질성분"),
                            Text("맛")
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              data[1].title,
                            ),
                            Text(
                              data[1].description,
                            ),
                            Text(data[1].price.toString()),
                            Text(data[1].serving.toString()),
                            Text(data[1].proteins.toString()),
                            Text("단백질성분"),
                            Text("맛")
                          ],
                        ),
                      )
                    ],
                  )
                ],
              );
            },
            error: (err, _) => const Text("error"),
            loading: () => const Center(child: CircularProgressIndicator())));
  }
}
