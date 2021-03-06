import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldcup/models/protein_model.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProteinModel>> getProteins() async {
    final ref = _firestore.collection("proteins").withConverter<ProteinModel>(
        fromFirestore: (snapshot, _) => ProteinModel.fromJson(snapshot.data()!),
        toFirestore: (protein, _) => protein.toJson());
    final QuerySnapshot<ProteinModel> response = await ref.get();

    return response.docs.map((p) => p.data()).toList();
  }

  Future<void> updateProteinByModel(ProteinModel p) async {
    final ref = _firestore.collection("proteins").withConverter<ProteinModel>(
        fromFirestore: (snapshot, _) => ProteinModel.fromJson(snapshot.data()!),
        toFirestore: (protein, _) => protein.toJson());
    final QuerySnapshot<ProteinModel> response = await ref.get();

    response.docs.forEach((obj) {
      if (obj.data().title == p.title) {
        // _firestore.collection("proteins").doc(obj.id).update({count: obj.data().count + 1});
      }
    });
  }
}

final firestoreProvider = Provider((ref) => FirestoreRepository());
final proteinsProvider = FutureProvider.autoDispose<List<ProteinModel>>(
    (ref) => ref.read(firestoreProvider).getProteins());
