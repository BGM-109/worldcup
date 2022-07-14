import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldcup/models/protein_model.dart';
import 'package:worldcup/repository/firestore_repository.dart';

final itemsProvider =
    StateNotifierProvider<PagingNotifier, AsyncValue<List<ProteinModel>>>(
        (ref) => PagingNotifier(repo: FirestoreRepository(), page: 2)..init());

class PagingNotifier extends StateNotifier<AsyncValue<List<ProteinModel>>> {
  PagingNotifier({required this.repo, required this.page})
      : super(const AsyncValue.loading());
  final FirestoreRepository repo;
  List<ProteinModel> items = [];
  final int page;
  int index = 0;
  List<ProteinModel> next = [];

  void init() async {
    var data = await repo.getProteins();
    data.shuffle();
    var result = data.sublist(0, 16);
    items = [...result];

    fetchData();
  }

  int get getIndex => index;

  Future<void> fetchData() async {
    state = AsyncValue.loading();
    Future.delayed(Duration(milliseconds: 500), () {
      int first = index * page;
      int last = (index + 1) * page;
      if (last - 1 <= items.length) {
        var list = items.sublist(first, last);
        state = AsyncValue.data([...list]);
      } else {
        resetIndex();
        fetchData();
      }
    });
  }

  Future<void> selectData(ProteinModel p) async {
    state = AsyncValue.loading();
    if (items.length == 2) {
      state = AsyncValue.data([p]);
    } else {
      index += 1;
      next = [...next, p];
      print(next);
      Future.delayed(Duration(milliseconds: 500), () {
        fetchData();
      });
    }
  }

  void resetIndex() {
    index = 0;
    items = [...next];
    next.clear();
  }
}

class PlayScreen extends ConsumerWidget {
  const PlayScreen({Key? key}) : super(key: key);
  static const String routeName = "/play_screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proteins = ref.watch(proteinsProvider);
    final itemsAsync = ref.watch(itemsProvider);
    final itemsRead = ref.read(itemsProvider.notifier);
    return Scaffold(
        body: itemsAsync.when(
            data: (data) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "${(itemsRead.index * itemsRead.page).toString()} / ${itemsRead.items.length}"),
                  const SizedBox(
                    height: 100,
                  ),
                  Row(
                    children: data
                        .map((p) => Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(p.igmUrl))),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          ref
                                              .read(itemsProvider.notifier)
                                              .selectData(p);
                                        },
                                        child: Text(p.title.toString())),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              );
            },
            error: (err, _) => Text("error"),
            loading: () => const Center(child: CircularProgressIndicator())));
  }
}
