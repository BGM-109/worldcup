
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldcup/models/protein_model.dart';
import 'package:worldcup/repository/firestore_repository.dart';

final resultProvider = StateProvider<ProteinModel?>((ref) => null);

final itemsProvider = StateNotifierProvider.family
    .autoDispose<PagingNotifier, AsyncValue<List<ProteinModel>>, int>(
        (ref, round) =>
    PagingNotifier(repo: FirestoreRepository(), page: 2, round: round)
      ..init());

class PagingNotifier extends StateNotifier<AsyncValue<List<ProteinModel>>> {
  PagingNotifier({required this.repo, required this.page, required this.round})
      : super(const AsyncValue.loading());
  final FirestoreRepository repo;
  final int round;
  List<ProteinModel> items = [];
  final int page;
  int index = 0;
  List<ProteinModel> next = [];

  void init() async {
    var data = await repo.getProteins();
    data.shuffle();
    var result = data.sublist(0, round);
    items = [...result];

    fetchData();
  }

  int get getIndex => index;

  Future<void> fetchData() async {
    state = const AsyncValue.loading();
    Future.delayed(const Duration(milliseconds: 500), () {
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
    state = const AsyncValue.loading();
    if (items.length == 2) {
      state = AsyncValue.data([p]);
    } else {
      index += 1;
      next = [...next, p];

      Future.delayed(const Duration(milliseconds: 500), () {
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